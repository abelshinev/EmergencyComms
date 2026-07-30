const registrationService = require('../services/registration.service');

function registerAgent(req, res) {
  const { agentId, fcmToken } = req.body;

  if (!agentId || !fcmToken) {
    return res.status(400).json({
      success: false,
      message: 'agentId and fcmToken are required',
    });
  }

  registrationService.register(agentId, fcmToken);

  return res.json({
    success: true,
  });
}

module.exports = {
  registerAgent,
};