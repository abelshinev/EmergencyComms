const http = require('http');

function sendRequest(options, postData = null) {
  return new Promise((resolve, reject) => {
    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => (data += chunk));
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, body: JSON.parse(data) });
        } catch (e) {
          resolve({ status: res.statusCode, rawBody: data });
        }
      });
    });

    req.on('error', (err) => reject(err));

    if (postData) {
      req.write(JSON.stringify(postData));
    }
    req.end();
  });
}

async function runTests() {
  console.log('==========================================');
  console.log('RUNNING PHASE 1A API VERIFICATION TESTS');
  console.log('==========================================\n');

  // Test 1: GET /health
  console.log('1. Testing GET /health ...');
  const res1 = await sendRequest({
    hostname: 'localhost',
    port: 3000,
    path: '/health',
    method: 'GET'
  });
  console.log(`Status: ${res1.status}`);
  console.log('Response:', JSON.stringify(res1.body, null, 2));

  // Test 2: POST /emergency (Known Device DEV001)
  console.log('\n2. Testing POST /emergency with DEV001 ...');
  const res2 = await sendRequest(
    {
      hostname: 'localhost',
      port: 3000,
      path: '/emergency',
      method: 'POST',
      headers: { 'Content-Type': 'application/json' }
    },
    { deviceId: 'DEV001' }
  );
  console.log(`Status: ${res2.status}`);
  console.log('Response:', JSON.stringify(res2.body, null, 2));

  // Test 3: POST /emergency (Known Device DEV002)
  console.log('\n3. Testing POST /emergency with DEV002 ...');
  const res3 = await sendRequest(
    {
      hostname: 'localhost',
      port: 3000,
      path: '/emergency',
      method: 'POST',
      headers: { 'Content-Type': 'application/json' }
    },
    { deviceId: 'DEV002' }
  );
  console.log(`Status: ${res3.status}`);
  console.log('Response:', JSON.stringify(res3.body, null, 2));

  // Test 4: POST /emergency (Unknown Device DEV999)
  console.log('\n4. Testing POST /emergency with Unknown DEV999 ...');
  const res4 = await sendRequest(
    {
      hostname: 'localhost',
      port: 3000,
      path: '/emergency',
      method: 'POST',
      headers: { 'Content-Type': 'application/json' }
    },
    { deviceId: 'DEV999' }
  );
  console.log(`Status: ${res4.status}`);
  console.log('Response:', JSON.stringify(res4.body, null, 2));

  // Test 5: POST /emergency (Missing deviceId)
  console.log('\n5. Testing POST /emergency with missing deviceId ...');
  const res5 = await sendRequest(
    {
      hostname: 'localhost',
      port: 3000,
      path: '/emergency',
      method: 'POST',
      headers: { 'Content-Type': 'application/json' }
    },
    {}
  );
  console.log(`Status: ${res5.status}`);
  console.log('Response:', JSON.stringify(res5.body, null, 2));

  console.log('\n==========================================');
  console.log('ALL PHASE 1A TESTS COMPLETED');
  console.log('==========================================');
}

runTests().catch(console.error);
