// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     const AndroidInitializationSettings initializationAndroidSettings =
//         AndroidInitializationSettings(
//       'logo',
//     );

//     const DarwinInitializationSettings initializationSettingIOS =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       defaultPresentSound: true,
//       defaultPresentAlert: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationAndroidSettings,
//       iOS: initializationSettingIOS,
//     );

//     await notificationPlugin.initialize(
//       initializationSettings,
//     );
//   }

//   Future<void> showNotification({
//     int? id,
//     String? title,
//     String? body,
//     String? payload,
//   }) async {
//     log('Showing notification: $id, $title, $body, $payload');
//     await notificationPlugin.show(
//       id!,
//       title,
//       body,
//       await notificationDetails(),
//       payload: payload,
//     );
//   }

//   Future<NotificationDetails> notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channelId1',
//         'daily',
//         // Specify the color
//         color: Color.fromARGB(255, 0, 68, 255),
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }
// }
