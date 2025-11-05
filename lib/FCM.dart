// lib/FCM.dart
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static Future<String?> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicita permissão
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      print("FCM Token gerado: $token");
      return token;
    } else {
      print("Permissão de notificação negada");
      return null;
    }
  }
}