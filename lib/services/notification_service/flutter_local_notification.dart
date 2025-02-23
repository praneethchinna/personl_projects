import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Use app icon instead of Firebase messaging icon
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Message received: ${message.notification?.title}');
      log('Message received: ${message.notification?.body}');
      // log('Message received: ${message.notification?.android?.imageUrl}');
      log('Message received: ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      ByteArrayAndroidBitmap? bigPicture;

      if (notification != null && android != null) {
        // String? imageUrl = message.notification?.android?.imageUrl;
        // final Uint8List? imageBytes = await _downloadImage(imageUrl!);
        // if (imageBytes != null) {
        //   bigPicture = ByteArrayAndroidBitmap(imageBytes);
        // }
        // log(imageUrl.toString());
        //
        // final bigPictureStyleInformation = imageUrl != null
        //     ? BigPictureStyleInformation(
        //         bigPicture as AndroidBitmap<Object>,
        //         contentTitle: notification.title,
        //         summaryText: notification.body,
        //         htmlFormatContentTitle: true,
        //         htmlFormatSummaryText: true,
        //       )
        //     : null;

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'your_channel_id',
              'your_channel_name',
              channelDescription: 'your_channel_description',
              enableVibration: true,
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              // styleInformation: bigPictureStyleInformation,
            ),
          ),
        );
      }
    });
  }

  Future<void> onSelectNotification(String? payload) async {
    // handle notification tap
    if (payload != null) {
      log("*****************$payload");
      debugPrint('Notification payload: $payload');
      // Add your notification tap handling logic here
    }
  }

  Future<Uint8List?> _downloadImage(String imageUrl) async {
    final dio = Dio();
    try {
      final response = await dio.get<Uint8List>(imageUrl,
          options: Options(responseType: ResponseType.bytes));
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null;
  }
}
