const { io } = require('socket.io-client');

const SERVER_URL = 'http://localhost:3000';
const AGENT_ID = process.argv[2] || 'AG001';

console.log(`[Agent CLI] Connecting to ${SERVER_URL} as ${AGENT_ID}...`);

const socket = io(SERVER_URL, {
  reconnection: true
});

socket.on('connect', () => {
  console.log(`[Agent CLI] Socket connected -> ${socket.id}`);
  console.log(`[Agent CLI] Registering presence for agentId: ${AGENT_ID}...`);

  socket.emit('agent:register', { agentId: AGENT_ID });
});

socket.on('agent:registered', (data) => {
  console.log(`[Agent CLI] Presence REGISTERED:`, data);
  console.log(`[Agent CLI] Ready and listening for incoming emergency calls...\n`);
});

socket.on('call:incoming', (data) => {
  console.log(`\n🚨 [AGENT CLI ALERT] INCOMING EMERGENCY CALL!`);
  console.log(`   From Passenger Socket: ${data.passengerSocketId}`);
  console.log(`   Device ID: ${data.deviceId}`);
  console.log(`   Timestamp: ${data.timestamp}\n`);
});

socket.on('disconnect', () => {
  console.log(`[Agent CLI] Disconnected from server.`);
});

socket.on('error', (err) => {
  console.error(`[Agent CLI] Error:`, err);
});
