const registeredAgents = new Map();

function register(agentId, fcmToken) {
  registeredAgents.set(agentId, {
    fcmToken,
    lastSeen: Date.now(),
  });
  console.log("[REGISTER] Registry:");
  console.log(Array.from(registeredAgents.entries()));
}

function get(agentId) {
  return registeredAgents.get(agentId);
}

function getToken(agentId) {
  return registeredAgents.get(agentId)?.fcmToken ?? null;
}

module.exports = {
  register,
  get,
  getToken,
};