import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PassengerApp());
}

class PassengerApp extends StatelessWidget {
  const PassengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Comms Passenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const EmergencyScreen(),
    );
  }
}

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _responseData;
  String? _errorMessage;

  // Uses localhost by default, adjustable via text field
  final TextEditingController _urlController = TextEditingController(
    text: 'http://localhost:3000/emergency',
  );
  final TextEditingController _deviceController = TextEditingController(
    text: 'DEV001',
  );

  Future<void> _sendEmergencyAlert() async {
    setState(() {
      _isLoading = true;
      _responseData = null;
      _errorMessage = null;
    });

    final url = _urlController.text.trim();
    final deviceId = _deviceController.text.trim();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'deviceId': deviceId}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _isLoading = false;
        _responseData = data;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Connection failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Assistance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Configuration Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'Server Endpoint',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _deviceController,
                      decoration: const InputDecoration(
                        labelText: 'Device ID',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Emergency Call Button
            SizedBox(
              height: 64,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _sendEmergencyAlert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.warning_amber_rounded, size: 32),
                label: Text(
                  _isLoading ? 'SENDING...' : 'EMERGENCY BUTTON',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            const Divider(),
            const SizedBox(height: 16),

            // Response Box
            const Text(
              'Response:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: _errorMessage != null
                      ? Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontFamily: 'monospace',
                          ),
                        )
                      : _responseData != null
                          ? Text(
                              const JsonEncoder.withIndent('  ')
                                  .convert(_responseData),
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontFamily: 'monospace',
                                fontSize: 14,
                              ),
                            )
                          : const Text(
                              'Press the Emergency Button to test lookup service...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
