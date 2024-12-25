// import 'dart:developer';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';

// class AwesomeNotificationServices {
//   factory AwesomeNotificationServices() => _notificationServices;
//   static final AwesomeNotificationServices _notificationServices =
//       AwesomeNotificationServices();
//   static final AwesomeNotifications awesomeNotifications =
//       AwesomeNotifications();

//   /// Initializes notification channels and groups
//   static Future<void> notificationConfiguration() async {
//     try {
//       await awesomeNotifications.initialize(
//         "resource://drawable/logo",
//         [
//           NotificationChannel(
//             channelGroupKey: 'daily_notifications_group',
//             channelKey: 'daily_notifications',
//             channelName: 'Daily Notifications',
//             channelDescription: 'Notification channel for daily reminders',
//             defaultColor: const Color(0xFF9D50DD),
//             ledColor: Colors.white,
//             playSound: true,
//             enableVibration: true,
//             defaultPrivacy: NotificationPrivacy.Public,
//             importance: NotificationImportance.High,
//             onlyAlertOnce: false,
//             criticalAlerts: true,
//           ),
//         ],
//         channelGroups: [
//           NotificationChannelGroup(
//               channelGroupKey: "daily_notifications_group",
//               channelGroupName: "Daily Notifications Group")
//         ],
//         debug: true,
//       );
//     } catch (error) {
//       log("Notification initialization error: $error");
//     }
//   }

//   /// Schedules a daily notification
//   static Future<void> scheduleDailyNotifications() async {
//     try {
//       String localTimeZone =
//           await AwesomeNotifications().getLocalTimeZoneIdentifier();
//       // Schedule for 10:00 AM
//       await awesomeNotifications.createNotification(
//         content: NotificationContent(
//           id: 1,
//           channelKey: 'daily_notifications',
//           title: 'Good Morning! ☀️',
//           body: 'Start your day with some grammar practice!',
//           icon: "resource://drawable/logo",
//           displayOnBackground: true,
//           duration: const Duration(seconds: 5),
//           autoDismissible: true,
//           category: NotificationCategory.Reminder,
//           displayOnForeground: true,
//           wakeUpScreen: true,
//           notificationLayout: NotificationLayout.Default,
//           roundedBigPicture: false,
//           roundedLargeIcon: true,
//         ),
//         // schedule: NotificationInterval(
//         //     interval: Duration(minutes: 1),
//         //     timeZone: localTimeZone,
//         //     allowWhileIdle: true,
//         //     repeats: true)
//         schedule: NotificationCalendar(
//           hour: 10,
//           minute: 10,
//           second: 0,
//           repeats: true,
//           allowWhileIdle: true,
//           timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
//         ),
//       );

//       // Schedule for 10:00 PM
//       await awesomeNotifications.createNotification(
//         content: NotificationContent(
//           id: 2,
//           channelKey: 'daily_notifications',
//           title: 'Good Evening! 🌙',
//           body: 'Wind down with a quick quiz!',
//           icon: "resource://drawable/logo",
//           displayOnBackground: true,
//           duration: const Duration(seconds: 5),
//           autoDismissible: true,
//           category: NotificationCategory.Recommendation,
//           displayOnForeground: true,
//           wakeUpScreen: true,
//           notificationLayout: NotificationLayout.Default,
//           roundedBigPicture: false,
//           roundedLargeIcon: true,
//         ),
//         // schedule: NotificationInterval(
//         //     interval: Duration(minutes: 2),
//         //     timeZone: localTimeZone,
//         //     allowWhileIdle: true,
//         //     repeats: true)
//         schedule: NotificationCalendar(
//           hour: 22,
//           minute: 10,
//           second: 0,
//           repeats: true,
//           allowWhileIdle: true,
//           timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
//         ),
//       );

//       log("Notifications scheduled successfully for 10:00 AM and 10:00 PM.");
//     } catch (error) {
//       log("Error scheduling notifications: $error");
//     }
//   }

//   /// Schedules a daily notification
//   static Future<void> scheduleInstantNotifications() async {
//     try {
//       // Schedule for 10:00 AM
//       await awesomeNotifications.createNotification(
//         content: NotificationContent(
//           id: 3,
//           channelKey: 'daily_notifications',
//           title: 'Good Morning! ☀️',
//           body: 'Start your day with some grammar practice!',
//           icon: "resource://drawable/logo",
//           displayOnBackground: true,
//           duration: const Duration(seconds: 5),
//           autoDismissible: true,
//           category: NotificationCategory.Reminder,
//           displayOnForeground: true,
//           wakeUpScreen: true,
//           notificationLayout: NotificationLayout.Default,
//           roundedBigPicture: false,
//           roundedLargeIcon: true,
//         ),
//       );
//     } catch (error) {
//       log("Error scheduling notifications: $error");
//     }
//   }

//   /// Cancels all scheduled notifications
//   static Future<void> cancelAllScheduledNotifications() async {
//     try {
//       await awesomeNotifications.cancelAllSchedules();
//       log("All scheduled notifications have been canceled.");
//     } catch (error) {
//       log("Error canceling scheduled notifications: $error");
//     }
//   }
// }
