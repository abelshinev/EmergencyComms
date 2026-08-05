import 'package:flutter/material.dart';
import 'package:agent_app/services/socket_service.dart';

class IncomingCallDialog extends StatelessWidget {
  final Map<String, dynamic> call;

  const IncomingCallDialog({
    super.key,
    required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("🚨 Emergency Alert"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Station: ${call["stationId"]}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Block: ${call["block"]}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text("Device: ${call["deviceId"]}"),

          const SizedBox(height: 16),

          const Text(
            "Passenger requesting emergency assistance.",
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            SocketService().rejectCurrentCall();
            Navigator.pop(context);
          },
          child: const Text("Reject"),
        ),

        ElevatedButton(
          onPressed: () {
            SocketService().acceptCurrentCall();
            Navigator.pop(context);
          },
          child: const Text("Accept"),
        ),
      ],
    );
  }
}