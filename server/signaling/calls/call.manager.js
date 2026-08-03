const crypto = require('crypto');

const activeCalls = new Map();

/**
 * Creates a new call session.
 */
function createCall({
  passengerSocketId,
  agentSocketId,
  deviceId,
  targetAgentId,
}) {
  const callId = crypto.randomUUID();

  const call = {
    callId,
    passengerSocketId,
    agentSocketId,
    deviceId,
    targetAgentId,
    state: 'initiated',
    createdAt: Date.now(),
  };

  activeCalls.set(callId, call);

  return call;
}

/**
 * Returns a call by its ID.
 */
function getCall(callId) {
  return activeCalls.get(callId);
}

/**
 * Updates the state of a call.
 */
function updateState(callId, state) {
  const call = activeCalls.get(callId);

  if (!call) {
    return null;
  }

  call.state = state;

  return call;
}

/**
 * Removes a completed/terminated call.
 */
function removeCall(callId) {
  activeCalls.delete(callId);
}

/**
 * Finds an active call by passenger socket.
 * Useful before we have a callId everywhere.
 */
function getCallByPassengerSocket(socketId) {
  for (const call of activeCalls.values()) {
    if (call.passengerSocketId === socketId) {
      return call;
    }
  }

  return null;
}

/**
 * Finds an active call by agent socket.
 */
function getCallByAgentSocket(socketId) {
  for (const call of activeCalls.values()) {
    if (call.agentSocketId === socketId) {
      return call;
    }
  }

  return null;
}

module.exports = {
  createCall,
  getCall,
  updateState,
  removeCall,
  getCallByPassengerSocket,
  getCallByAgentSocket,
};