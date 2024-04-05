import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../data/endpoints.dart';

abstract class PushNotification {
  Future<void> initializeNotification();
  Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  });
  Future<void> sendPushNotifs({
    required String title,
    required String body,
    required String token,
  });
}

class PushNotificationImpl implements PushNotification {
  PushNotificationImpl(this.localNotification);

  final FlutterLocalNotificationsPlugin localNotification;

  @override
  Future<void> initializeNotification() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    /// initialize Local Notification
    const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings());
    await localNotification.initialize(initializationSettings);

    const channel = AndroidNotificationChannel(
      'com.example.recipe_hub', // id
      'Recipe Hub', // title
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      ledColor: Color(0xFF9769EC),
      enableLights: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;
      final ios = message.notification?.apple;
      if (notification != null && android != null) {
        localNotification.show(
            message.hashCode,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id,
              channel.name,
            )));
      }
      if (notification != null && ios != null) {
        localNotification.show(
            message.hashCode,
            message.notification!.title,
            message.notification!.body,
            const NotificationDetails(iOS: DarwinNotificationDetails()));
      }
    });
  }

  @override
  Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'com.example.recipe_hub',
      'Recipe Hub',
      channelDescription: 'Channel description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    final int notificationId = DateTime.now().millisecondsSinceEpoch;
    await flutterLocalNotificationsPlugin.show(
        notificationId, title, body, notificationDetails,
        payload: payload);
  }

  @override
  Future<void> sendPushNotifs(
      {required String title,
      required String body,
      required String token}) async {
    try {
      log('start');
      await http.post(
        Uri.parse(EndPoints.firebaseNotifs),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': EndPoints.authorizationKey
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "com.example.recipe_hub"
            },
            "to": token,
          },
        ),
      );
      log('end');
    } catch (e) {
      if (kDebugMode) {
        log('Error push notifs');
      }
    }
  }
}
