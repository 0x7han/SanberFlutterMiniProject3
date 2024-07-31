import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static ValueNotifier<String> payload = ValueNotifier('');

  void setPayload(String value) => payload.value = value;

  static AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    'Local notification',
    'Rpedia',
    channelDescription:
        'Hallo Raihan ada barang bagus loh hari ini 😁, buruan checkout',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    playSound: true,
    enableVibration: true,
  );

  static NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);


  Future<void> init() async {
    const initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: initAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        setPayload(details.payload ?? '');

      },
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    
  }
}
