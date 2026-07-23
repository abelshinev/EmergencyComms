require('dotenv').config();
const http = require('http');
const express = require('express');
const cors = require('cors');
const logger = require('./config/logger');
const lookupService = require('./lookup/services/lookup.service');
const emergencyRoutes = require('./lookup/routes/emergency.routes');
const initSocket = require('./signaling/socket');

const app = express();
const server = http.createServer(app);
const PORT = process.env.PORT || 3000;

// Initialize in-memory cache for lookup service
lookupService.init();

// Middleware
app.use(cors());
app.use(express.json());

// Attach Socket.IO signaling server
initSocket(server);

// Health Check Endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Emergency Lookup Endpoint
app.use('/', emergencyRoutes);

// Global 404 handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

server.listen(PORT, () => {
  logger.info(`Server listening on port ${PORT}`);
});
