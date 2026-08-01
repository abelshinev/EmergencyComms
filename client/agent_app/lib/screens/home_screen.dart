import 'package:flutter/material.dart';

enum AgentState {
  waiting,
  incoming,
  connected,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  AgentState state = AgentState.waiting;

  String deviceId = "";
  String stationId = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agent Console"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Center(
          child: switch (state) {

            AgentState.waiting => _waiting(),

            AgentState.incoming => _incoming(),

            AgentState.connected => _connected(),
          },
        ),
      ),
    );
  }

  Widget _waiting() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [

        Icon(
          Icons.support_agent,
          size: 96,
          color: Colors.green,
        ),

        SizedBox(height: 24),

        Text(
          "ONLINE",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 12),

        Text(
          "Waiting for emergency...",
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _incoming() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        const Icon(
          Icons.warning_rounded,
          color: Colors.red,
          size: 100,
        ),

        const SizedBox(height: 24),

        const Text(
          "INCOMING EMERGENCY",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        Text("Device: $deviceId"),

        Text("Station: $stationId"),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            FilledButton.tonal(
              onPressed: () {

              },
              child: const Text("Reject"),
            ),

            FilledButton(
              onPressed: () {

              },
              child: const Text("Accept"),
            ),
          ],
        )
      ],
    );
  }

  Widget _connected() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        const Icon(
          Icons.call,
          color: Colors.green,
          size: 96,
        ),

        const SizedBox(height: 24),

        const Text(
          "Connected",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Text("Passenger: $deviceId"),

        const SizedBox(height: 32),

        FilledButton(
          onPressed: () {

          },
          child: const Text("End Call"),
        )
      ],
    );
  }
}