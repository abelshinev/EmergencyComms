const http = require('http');
const { io } = require('socket.io-client');

const SERVER_URL = 'http://localhost:3000';
const DEVICE_ID = process.argv[2] || 'DEV001';

function performLookup(deviceId) {
  return new Promise((resolve, reject) => {
    console.log(`[Passenger CLI] Step 1: Performing HTTP POST /emergency for device: ${deviceId}...`);
    const postData = JSON.stringify({ deviceId });

    const req = http.request(
      {
        hostname: 'localhost',
        port: 3000,
        path: '/emergency',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(postData)
        }
      },
      (res) => {
        let body = '';
        res.on('data', (chunk) => (body += chunk));
        res.on('end', () => {
          try {
            resolve({ status: res.statusCode, data: JSON.parse(body) });
          } catch (e) {
            reject(e);
          }
        });
      }
    );

    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

async function runPassengerTest() {
  try {
    const lookupRes = await performLookup(DEVICE_ID);
    console.log(`[Passenger CLI] Lookup Response (HTTP ${lookupRes.status}):`, lookupRes.data);

    if (!lookupRes.data.success || !lookupRes.data.agent) {
      console.error(`[Passenger CLI] Lookup failed:`, lookupRes.data.message);
      process.exit(1);
    }

    const targetAgentId = lookupRes.data.agent.agentId;
    console.log(`[Passenger CLI] Resolved Target Agent: ${targetAgentId}`);

    console.log(`\n[Passenger CLI] Step 2: Connecting to Socket.IO signaling server...`);
    const socket = io(SERVER_URL);

    socket.on('connect', () => {
      console.log(`[Passenger CLI] Socket connected -> ${socket.id}`);
      console.log(`[Passenger CLI] Emitting call:initiate targeting Agent: ${targetAgentId}...`);

      socket.emit('call:initiate', {
        targetAgentId,
        deviceId: DEVICE_ID
      });
    });

    socket.on('call:alerting', (data) => {
      console.log(`\n✅ [Passenger CLI] CALL ALERTING ACKNOWLEDGED!`);
      console.log(`   Alert successfully delivered to Agent socket: ${data.agentSocketId}`);
      setTimeout(() => {
        socket.disconnect();
        process.exit(0);
      }, 1000);
    });

    socket.on('call:rejected', (data) => {
      console.log(`\n❌ [Passenger CLI] CALL REJECTED / UNABLE TO REACH AGENT!`);
      console.log(`   Reason: ${data.reason}`);
      setTimeout(() => {
        socket.disconnect();
        process.exit(1);
      }, 1000);
    });
  } catch (err) {
    console.error(`[Passenger CLI] Error:`, err);
    process.exit(1);
  }
}

runPassengerTest();
