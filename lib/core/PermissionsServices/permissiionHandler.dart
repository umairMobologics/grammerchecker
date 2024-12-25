import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> checkPermissions(Permission permission) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      log('Access Denied');
      return false;
      // showAlertDialog(context);
    } else if (status.isLimited) {
      log('Limited access');
      return false;
      // showAlertDialog(context);
    } else if (status.isPermanentlyDenied) {
      log('Permanently Denied');
      return false;
      // showAlertDialog(context);
    } else if (status.isGranted) {
      log('Access Granted');
      return true;
    } else {
      return false;
    }
  }

  static bool _isRequestingPermissions = false;

  static Future<void> requestPermissions() async {
    // Check if a permission request is already in progress
    if (_isRequestingPermissions) {
      log('Permission request is already in progress. Please wait.');
      return;
    }

    try {
      // Mark the permission request as in progress
      _isRequestingPermissions = true;

      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();

      bool allGranted = true;

      statuses.forEach((permission, status) {
        if (status.isDenied) {
          log('${permission.toString()} Access Denied');
          allGranted = false;
        } else if (status.isLimited) {
          log('${permission.toString()} Limited access');
          allGranted = false;
        } else if (status.isPermanentlyDenied) {
          log('${permission.toString()} Permanently Denied');
          allGranted = false;
        } else if (status.isGranted) {
          log("${permission.toString()} Permission Granted");
        }
      });

      if (!allGranted) {
        log('Not all permissions are granted');
      } else {
        log('All permissions granted');
      }
    } catch (e) {
      log('Error requesting permissions: $e');
    } finally {
      // Mark the permission request as completed
      _isRequestingPermissions = false;
    }
  }

  static void showAlertDialog(BuildContext context, pName) {
    showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Permission Denied'),
        content:
            Text('Please allow access to $pName permissions from Settings.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  // // Check if notification permission is granted
  // static Future<bool> isNotificationPermissionGranted() async {
  //   PermissionStatus status = await Permission.notification.status;
  //   return status.isGranted;
  // }

  // // Request notification permission and handle denial
  // static Future<bool> requestNotificationPermission() async {
  //   PermissionStatus status = await Permission.notification.request();

  //   // Check if permission is granted after the request
  //   if (status.isGranted) {
  //     return true; // Permission granted
  //   } else if (status.isDenied) {
  //     // Handle case when user denies permission (e.g., show a message)
  //     log("Notification permission denied. Please enable it from the settings.");
  //     return false; // Permission denied
  //   } else if (status.isPermanentlyDenied) {
  //     // Handle case when user permanently denies permission (e.g., open settings)
  //     openAppSettings();
  //     return false; // Permission permanently denied
  //   }
  //   return false; // Other cases
  // }

  // // Method to handle notification permission request process
  // static Future<bool> handleNotificationPermission() async {
  //   bool isGranted = await isNotificationPermissionGranted();
  //   if (!isGranted) {
  //     bool permissionRequested = await requestNotificationPermission();
  //     return permissionRequested;
  //   }
  //   return isGranted; // Permission already granted
  // }
}
