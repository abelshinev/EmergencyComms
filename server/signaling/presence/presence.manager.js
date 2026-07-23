const logger = require('../../config/logger');

class PresenceManager {
  constructor() {
    // Map<agentId, { socketId, connectedAt }>
    this.agents = new Map();
    // Map<socketId, agentId>
    this.sockets = new Map();
  }

  registerAgent(agentId, socketId) {
    // If agent was previously registered with another socket, clean up old socket entry
    const existing = this.agents.get(agentId);
    if (existing && existing.socketId !== socketId) {
      this.sockets.delete(existing.socketId);
    }

    const info = {
      socketId,
      connectedAt: new Date().toISOString()
    };

    this.agents.set(agentId, info);
    this.sockets.set(socketId, agentId);

    logger.info(`Agent registered -> ID: ${agentId} (socket: ${socketId})`);
    return info;
  }

  removeBySocketId(socketId) {
    const agentId = this.sockets.get(socketId);
    if (agentId) {
      this.sockets.delete(socketId);
      this.agents.delete(agentId);
      logger.info(`Agent disconnected -> ID: ${agentId} (socket: ${socketId})`);
      return agentId;
    }
    return null;
  }

  getAgentSocketId(agentId) {
    const agent = this.agents.get(agentId);
    return agent ? agent.socketId : null;
  }

  isAgentOnline(agentId) {
    return this.agents.has(agentId);
  }

  getOnlineAgents() {
    const list = [];
    this.agents.forEach((val, key) => {
      list.push({ agentId: key, socketId: val.socketId, connectedAt: val.connectedAt });
    });
    return list;
  }
}

module.exports = new PresenceManager();
