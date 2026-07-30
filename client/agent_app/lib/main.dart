import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background notification: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler);

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();

  debugPrint("Permission: ${settings.authorizationStatus}");

  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("AGENT FCM TOKEN: $token");

  runApp(const AgentApp());
}

class AgentApp extends StatelessWidget {
  const AgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          "Foreground notification: ${message.notification?.title}");
      debugPrint("${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification tapped");
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agent App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Agent App"),
        ),
        body: const Center(
          child: Text(
            "Waiting for emergency notifications...",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}