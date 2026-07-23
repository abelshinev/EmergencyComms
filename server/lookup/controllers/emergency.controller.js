const lookupService = require('../services/lookup.service');
const logger = require('../../config/logger');
const { ERRORS } = require('../../config/constants');

exports.handleEmergency = (req, res) => {
  logger.info('POST /emergency received');

  const { deviceId } = req.body || {};

  if (!deviceId) {
    logger.warn(`Request rejected: ${ERRORS.MISSING_DEVICE_ID}`);
    return res.status(400).json({
      success: false,
      message: ERRORS.MISSING_DEVICE_ID
    });
  }

  logger.info(`Device ID: ${deviceId}`);

  const resolved = lookupService.resolveDevice(deviceId);

  if (!resolved) {
    logger.warn(`Device resolution failed for ID: ${deviceId}`);
    logger.info('Response sent (404)');
    return res.status(404).json({
      success: false,
      message: ERRORS.DEVICE_NOT_FOUND
    });
  }

  logger.info(`Device resolved → ${resolved.stationId} / Block ${resolved.block}`);
  if (resolved.agent) {
    logger.info(`Agent resolved → ${resolved.agent.agentId}`);
  } else {
    logger.warn(`No agent assigned to ${resolved.stationId} / Block ${resolved.block}`);
  }

  const responsePayload = {
    success: true,
    deviceId: resolved.deviceId,
    stationId: resolved.stationId,
    block: resolved.block,
    agent: resolved.agent
  };

  logger.info('Response sent (200)');
  return res.status(200).json(responsePayload);
};
