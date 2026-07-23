require('dotenv').config();
const express = require('express');
const cors = require('cors');
const logger = require('./config/logger');
const lookupService = require('./lookup/services/lookup.service');
const emergencyRoutes = require('./lookup/routes/emergency.routes');

const app = express();
const PORT = process.env.PORT || 3000;

// Initialize in-memory cache for devices and stations
lookupService.init();

// Middleware
app.use(cors());
app.use(express.json());

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

app.listen(PORT, () => {
  logger.info(`Server listening on port ${PORT}`);
});
