const presenceManager = require('../presence/presence.manager');
const logger = require('../../config/logger');

function registerSignalingHandlers(io, socket) {
  logger.info(`Socket connected -> ${socket.id}`);

  // Agent registers presence
  socket.on('agent:register', (data) => {
    const { agentId } = data || {};
    if (!agentId) {
      logger.warn(`[Socket ${socket.id}] agent:register missing agentId`);
      return socket.emit('error', { message: 'agentId is required for registration' });
    }

    presenceManager.registerAgent(agentId, socket.id);
    socket.emit('agent:registered', { success: true, agentId, socketId: socket.id });
  });

  // Passenger initiates emergency alert towards an resolved agent
  socket.on('call:initiate', (data) => {
    const { targetAgentId, deviceId } = data || {};
    logger.info(`[Socket ${socket.id}] call:initiate towards ${targetAgentId} (device: ${deviceId})`);

    if (!targetAgentId) {
      return socket.emit('call:rejected', { reason: 'targetAgentId is required' });
    }

    const agentSocketId = presenceManager.getAgentSocketId(targetAgentId);

    if (!agentSocketId) {
      logger.warn(`[Socket ${socket.id}] Target agent ${targetAgentId} is OFFLINE`);
      return socket.emit('call:rejected', {
        success: false,
        reason: 'Agent offline',
        targetAgentId
      });
    }

    logger.info(`Relaying call:incoming to Agent ${targetAgentId} (socket: ${agentSocketId})`);

    // Relay event to target agent socket
    io.to(agentSocketId).emit('call:incoming', {
      passengerSocketId: socket.id,
      deviceId,
      targetAgentId,
      timestamp: new Date().toISOString()
    });

    // Acknowledge passenger that alert was delivered to agent
    socket.emit('call:alerting', {
      success: true,
      targetAgentId,
      agentSocketId
    });
  });

  // Handle client disconnect
  socket.on('disconnect', (reason) => {
    const agentId = presenceManager.removeBySocketId(socket.id);
    if (!agentId) {
      logger.info(`Socket disconnected -> ${socket.id} (reason: ${reason})`);
    }
  });
}

module.exports = registerSignalingHandlers;
