import 'package:flutter/material.dart';
import 'package:passenger_app/services/api_service.dart';
import 'package:passenger_app/services/socket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TextEditingController initialized with DEV001 as requested
  final TextEditingController _controller = TextEditingController(text: 'DEV001');

  String _status = 'Ready';
  bool _loading = false;
  final ApiService _api = ApiService();

  Future<void> _triggerEmergency() async {
    setState(() {
      _loading = true;
      _status = "Sending emergency...";
    });
    try {
      final response = await _api.triggerEmergency(
        deviceId: _controller.text,
      );
      print(response);

      final agentId = response["agent"]["agentId"];

      final socket = SocketService();

      await socket.connect();
      
      socket.initiateCall(agentId: agentId, deviceId: _controller.text);

      setState(() {
        _status = 'Connected to ${response["agent"]["agentId"]}';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to send emergency';
      });
      print(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Console'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Device ID',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _loading ? null : _triggerEmergency,
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text(
                'EMERGENCY',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Status:\n$_status',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
