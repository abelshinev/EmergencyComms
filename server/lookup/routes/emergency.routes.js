const express = require('express');
const router = express.Router();
const emergencyController = require('../controllers/emergency.controller');

router.post('/emergency', emergencyController.handleEmergency);

module.exports = router;
