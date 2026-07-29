import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/app.dart';
import 'services/notification_service.dart';
import 'services/api_service.dart'

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationService = NotificationService();
  final fcmToken = await notificationService.initialize();

  if (fcmToken != null) {
    final api = ApiService();

    await api.registerAgent(
      agentId: 'AGENT001',
      fcmToken: fcmToken
    )
  }

  print("Main received token: $fcmToken");

  runApp(const StationAlertsApp());
}