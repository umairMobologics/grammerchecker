// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:grammer_checker_app/core/localNotificationServices/AwesomeNotifications.dart';
// import 'package:workmanager/workmanager.dart';

// class BackgroundServices {
//   static Workmanager workManager = Workmanager();

//   // Initialize WorkManager
//   static Future<void> initializeBackgroundService() async {
//     log("Initializing WorkManager...");
//     await workManager.initialize(callbackDispatcher, isInDebugMode: false);
//   }

//   // Register tasks with specific times
//   static Future<void> registerTaskFunction() async {
//     // Schedule for 10:00 AM
//     await _scheduleDailyTask("dayTask", "dayNotificationTask", 10);

//     // Schedule for 10:00 PM
//     await _scheduleDailyTask("nightTask", "nightNotificationTask", 22);
//   }

//   // Helper function to calculate delay and register periodic tasks
//   static Future<void> _scheduleDailyTask(
//       String uniqueName, String taskName, int targetHour) async {
//     var now = DateTime.now();
//     var targetTime = DateTime(now.year, now.month, now.day, targetHour, 0, 0);

//     // If target time is before the current time, schedule for the next day
//     if (now.isAfter(targetTime)) {
//       targetTime = targetTime.add(const Duration(days: 1));
//     }

//     var initialDelay = targetTime.difference(now);

//     log("Registering $uniqueName with initial delay: $initialDelay");

//     await workManager.registerPeriodicTask(
//       uniqueName,
//       taskName,
//       frequency: const Duration(minutes: 15), // Repeat every 24 hours
//       // initialDelay: initialDelay,
//       initialDelay: Duration(seconds: 30),
//       constraints: Constraints(
//         networkType: NetworkType.not_required,
//         requiresBatteryNotLow: false,
//         requiresDeviceIdle: false,
//         requiresStorageNotLow: false,
//         requiresCharging: false,
//       ),
//     );
//   }
// }

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Workmanager().executeTask((task, inputData) async {
//     log("Task received: $task");
//     if (task == "nightNotificationTask") {
//            AwesomeNotificationServices.createScheduleNotification(
            
//             });
//       // Show notification for the night task
//       // NotificationService().showNotification(
//       //   id: 1,
//       //   title: "Level Up Your Grammar",
//       //   body: "Play our Fun Grammar Game and boost your Writing Game.",
//       //   payload: "",
//       // );
//     } else if (task == "dayNotificationTask") {
//       // Show notification for the day task
//       // NotificationService().showNotification(
//       //   id: 2,
//       //   title: "Write Better, Faster",
//       //   body: "Create compelling content with Ai Writing Assistant",
//       //   payload: "",
//       // );
//     }
//     return Future.value(true);
//   });
// }
