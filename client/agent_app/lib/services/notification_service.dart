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

    return token;
  }
}