import 'package:flutter/material.dart';

void main() {
  runApp(const AgentApp());
}

class AgentApp extends StatelessWidget {
  const AgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Comms Agent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agent Dashboard'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Agent App Shell (Phase 2+)',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
