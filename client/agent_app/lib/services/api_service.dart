import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Replace with your PC's LAN IP when testing on a real device.
  static const String baseUrl = 'http://192.168.0.170:3000';
  
  Future<void> registerAgent({
    required String agentId,
    required String fcmToken,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'agentId': agentId,
        'fcmToken': fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      print('Agent registered successfully.');
    } else {
      print('Registration failed: ${response.statusCode}');
      print(response.body);
    }
  }
}