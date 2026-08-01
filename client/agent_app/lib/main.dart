import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'app/app.dart';

import 'services/notification_service.dart';
import 'services/api_service.dart';
import 'services/socket_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationService = NotificationService();
  final fcmToken = await notificationService.initialize();

  if (fcmToken != null) {
    final api = ApiService();

    // Register the FCM token with the backend
    await api.registerAgent(
      agentId: 'AG001',
      fcmToken: fcmToken,
    );

    // Connect to the signaling server
    final socketService = SocketService();

    socketService.connect('AG001');

    print("Socket connection initialized.");
  }

  print("Main received token: $fcmToken");

  runApp(const StationAlertsApp());
}