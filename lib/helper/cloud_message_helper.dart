import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sanber_flutter_mini_project_3/helper/notification_helper.dart';


class CloudMessageHelper {
  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();

    final fcmToken = await FirebaseMessaging.instance.getToken();

    print('Token $fcmToken');
    FirebaseMessaging.instance.getInitialMessage().then((value) => NotificationHelper.payload.value = jsonEncode({
      "title" : value?.notification?.title,
      "body" : value?.notification?.body,
      "data" : value?.data,
    }) );

    FirebaseMessaging.onMessageOpenedApp.listen((value) => NotificationHelper.payload.value = jsonEncode({
      "title" : value.notification?.title,
      "body" : value.notification?.body,
      "data" : value.data,
    }));

    FirebaseMessaging.onMessage.listen((message) async { 
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if(notification != null && android != null) {
        await NotificationHelper.flutterLocalNotificationsPlugin.show(
          Random().nextInt(99),
          notification.title,
          notification.body,
          NotificationHelper.notificationDetails,
          payload: jsonEncode({
            "title" : notification.title,
            "body" : notification.body,
            "data" : message.data,
          }));
      }
     });
  }

  static Map<String, dynamic> tryDecode(data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return {};
    }
  }
}