
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
    } 
    else if  (status.isGranted){
        log('Access Granted');
      return true;
      }
      else {
         return false;
       
   
    }
  }
  
  static Future<void> requestPermissions() async {
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
  }

  static void showAlertDialog(BuildContext context,  pName) {
    showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Permission Denied'),
        content:  Text('Please allow access to $pName permissions from Settings.'),
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
}