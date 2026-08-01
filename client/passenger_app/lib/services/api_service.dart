import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> triggerEmergency({
    required String deviceId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/emergency'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'deviceId': deviceId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Emergency request failed');
    }

    return jsonDecode(response.body);
  }
}