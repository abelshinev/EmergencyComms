const { Server } = require('socket.io');
const logger = require('../config/logger');
const registerSignalingHandlers = require('./handlers/signaling.handler');

function initSocket(httpServer) {
  const io = new Server(httpServer, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST']
    }
  });

  io.on('connection', (socket) => {
    registerSignalingHandlers(io, socket);
  });

  logger.info('[Socket.IO] Signaling server initialized');
  return io;
}

module.exports = initSocket;
