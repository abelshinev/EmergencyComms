import 'package:flutter/material.dart';

class IncomingCallDialog extends StatelessWidget {
  final Map<String, dynamic> call;

  const IncomingCallDialog({
    super.key,
    required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Emergency Alert"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Device: ${call["deviceId"]}"),
          const SizedBox(height: 8),
          const Text(
            "Passenger is requesting assistance.",
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Reject"),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Accept"),
        ),
      ],
    );
  }
}