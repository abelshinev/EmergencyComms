import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> initialize() async {
    NotificationSettings settings =
    await _messaging.requestPermission();

    print('Notification permission: ${settings.authorizationStatus}');

    final token = await _messaging.getToken();

    print('========================================');
    print('FCM TOKEN:');
    print(token);
    print('========================================');

    // App is OPEN
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('========== FOREGROUND MESSAGE ==========');
      print('Title: ${message.notification?.title}');
      print('Body : ${message.notification?.body}');
      print('Data : ${message.data}');
      print('========================================');
    });

    // User taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened!');
      print(message.data);
    });

    return token;
  }
}