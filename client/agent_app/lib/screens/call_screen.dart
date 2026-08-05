import 'package:flutter/material.dart';
import 'package:agent_app/services/socket_service.dart';

class CallScreen extends StatelessWidget {
  final String stationId;
  final String block;
  final String deviceId;

  const CallScreen({
    super.key,
    required this.stationId,
    required this.block,
    required this.deviceId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Emergency Call"),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.support_agent,
              size: 120,
              color: Colors.white,
            ),

            const SizedBox(height: 30),

            const Text(
              "Emergency Call",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Connected",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Station: $stationId",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Block: $block",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Device: $deviceId",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: const Icon(Icons.call_end),

                onPressed: () {
                  SocketService().endCurrentCall();

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}