import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("STEP 1: Flutter initialized");

  try {
    await Firebase.initializeApp();
    debugPrint("STEP 2: Firebase initialized");

    final messaging = FirebaseMessaging.instance;
    debugPrint("STEP 3: Firebase Messaging instance created");

    final settings = await messaging.requestPermission();
    debugPrint("STEP 4: Permission requested");
    debugPrint("Permission status: ${settings.authorizationStatus}");

    final token = await messaging.getToken();
    debugPrint("STEP 5: Token received");

    debugPrint("================================");
    debugPrint("FCM TOKEN: $token");
    debugPrint("================================");
  } catch (e, stackTrace) {
    debugPrint("❌ Firebase Error: $e");
    debugPrint(stackTrace.toString());
  }

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
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}