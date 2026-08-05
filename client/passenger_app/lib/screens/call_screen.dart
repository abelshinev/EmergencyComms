import 'package:flutter/material.dart';
import 'package:passenger_app/services/socket_service.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title: const Text("Emergency Call"),
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
              "Connected to Station Agent",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Emergency Voice Call",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  SocketService().endCurrentCall();
                },
                child: const Icon(Icons.call_end),
              ),
            ),
          ],
        ),
      ),
    );
  }
}