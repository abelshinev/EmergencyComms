const { initializeApp, cert } = require('firebase-admin/app');
const { getMessaging } = require('firebase-admin/messaging');

const serviceAccount = require('../serviceAccountKey.json');
const agentTokens = require('../lookup/data/agentTokens.json');

initializeApp({
  credential: cert(serviceAccount),
});

console.log('[FCM] Firebase Admin initialized');

async function sendEmergencyNotification(agentId, deviceId) {
  // Find the agent's FCM token
  const agent = agentTokens.find(a => a.agentId === agentId);

  if (!agent) {
    console.log(`[FCM] No token found for agent ${agentId}`);
    return;
  }

  const message = {
    token: agent.fcmToken,
    notification: {
      title: 'Emergency Alert',
      body: `Emergency call received from device ${deviceId}`,
    },
    data: {
      agentId,
      deviceId,
    },
  };

  try {
    const response = await getMessaging().send(message);
    console.log('[FCM] Notification sent:', response);
  } catch (error) {
    console.error('[FCM] Error sending notification:', error.message);
  }
}

module.exports = {
  sendEmergencyNotification,
};