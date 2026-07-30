const registeredAgents = new Map();

function register(agentId, fcmToken) {
  registeredAgents.set(agentId, {
    fcmToken,
    lastSeen: Date.now(),
  });
}

function get(agentId) {
  return registeredAgents.get(agentId);
}

module.exports = {
  register,
  get,
};