const presenceManager = require('../presence/presence.manager');
const callManager = require('../calls/call.manager');
const logger = require('../../config/logger');
const { sendEmergencyNotification } = require('../../notifications/fcm.service');

function registerSignalingHandlers(io, socket) {
  logger.info(`Socket connected -> ${socket.id}`);

  // Agent registers presence
  socket.on('agent:register', (data) => {
    const { agentId } = data || {};

    if (!agentId) {
      logger.warn(`[Socket ${socket.id}] agent:register missing agentId`);

      return socket.emit('error', {
        message: 'agentId is required for registration',
      });
    }

    presenceManager.registerAgent(agentId, socket.id);

    socket.emit('agent:registered', {
      success: true,
      agentId,
      socketId: socket.id,
    });
  });

  // Passenger initiates emergency alert
  socket.on('call:initiate', async (data) => {
    const { targetAgentId, deviceId, stationId, block } = data || {};

    logger.info(
      `[Socket ${socket.id}] call:initiate towards ${targetAgentId} (device: ${deviceId})`
    );

    if (!targetAgentId) {
      return socket.emit('call:rejected', {
        reason: 'targetAgentId is required',
      });
    }

    const agentSocketId = presenceManager.getAgentSocketId(targetAgentId);

    // Agent offline
    if (!agentSocketId) {
      logger.warn(
        `[Socket ${socket.id}] Target agent ${targetAgentId} is OFFLINE`
      );

      await sendEmergencyNotification(targetAgentId, deviceId);

      return socket.emit('call:rejected', {
        success: false,
        reason: 'Agent offline',
        targetAgentId,
      });
    }

    // Create call session
    const call = callManager.createCall({
      passengerSocketId: socket.id,
      agentSocketId,
      deviceId,
      targetAgentId,
      stationId,
      block,
    });

    logger.info(
      `Created Call ${call.callId} (${deviceId} -> ${targetAgentId})`
    );

    // Notify agent
    io.to(agentSocketId).emit('call:incoming', {
      callId: call.callId,
      deviceId,
      stationId,
      block,
      targetAgentId,
      timestamp: new Date().toISOString(),
    });

    // Notify passenger
    socket.emit('call:alerting', {
      success: true,
      callId: call.callId,
      targetAgentId,
    });
  });

  // Agent accepts call
  socket.on('call:accepted', (data) => {
    const { callId } = data;

    const call = callManager.getCall(callId);

    if (!call) {
      logger.warn(`Unknown call ${callId}`);
      return;
    }

    callManager.updateState(callId, 'accepted');

    logger.info(`Call ${callId} accepted`);

    io.to(call.passengerSocketId).emit('call:accepted', {
      callId,
      deviceId: call.deviceId,
    });
  });

  // Relay SDP Offer -> Agent
  socket.on('webrtc:offer', (data) => {
    const { callId, sdp, type } = data;

    const call = callManager.getCall(callId);

    if (!call) {
      logger.warn(`Received WebRTC offer for unknown call ${callId}`);
      return;
    }

    io.to(call.agentSocketId).emit('webrtc:offer', {
      callId,
      sdp,
      type,
    });

    logger.info(`Relayed WebRTC offer for ${callId}`);
  });

  // Relay SDP Answer -> Passenger
  socket.on('webrtc:answer', (data) => {
    const { callId, sdp, type } = data;

    const call = callManager.getCall(callId);

    if (!call) {
      logger.warn(`Received WebRTC answer for unknown call ${callId}`);
      return;
    }

    io.to(call.passengerSocketId).emit('webrtc:answer', {
      callId,
      sdp,
      type,
    });

    logger.info(`Relayed WebRTC answer for ${callId}`);
  });

  // Relay ICE Candidates
  socket.on('webrtc:ice-candidate', (data) => {
    const {
      callId,
      candidate,
      sdpMid,
      sdpMLineIndex,
    } = data;

    const call = callManager.getCall(callId);

    if (!call) {
      logger.warn(
        `Received ICE candidate for unknown call ${callId}`
      );
      return;
    }

    // Determine sender and forward to the other peer
    const destination =
      socket.id === call.passengerSocketId
        ? call.agentSocketId
        : call.passengerSocketId;

    io.to(destination).emit('webrtc:ice-candidate', {
      callId,
      candidate,
      sdpMid,
      sdpMLineIndex,
    });

    logger.info(`Relayed ICE candidate for ${callId}`);
  });

  // End call
  socket.on('call:end', (data) => {
    const { callId } = data;

    const call = callManager.getCall(callId);

    if (!call) {
      return;
    }

    io.to(call.passengerSocketId).emit('call:ended', {
      callId,
    });

    io.to(call.agentSocketId).emit('call:ended', {
      callId,
    });

    callManager.removeCall(callId);

    logger.info(`Call ${callId} removed`);
  });

  // Disconnect
  socket.on('disconnect', (reason) => {
    const agentId = presenceManager.removeBySocketId(socket.id);

    if (!agentId) {
      logger.info(
        `Socket disconnected -> ${socket.id} (reason: ${reason})`
      );
    }
  });
}

module.exports = registerSignalingHandlers;