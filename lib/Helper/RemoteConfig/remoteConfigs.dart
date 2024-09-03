import 'dart:developer';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';

class RemoteConfig {
  static final _config = FirebaseRemoteConfig.instance;

  static const _defaultValues = {
    "apiUrl":
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=",
    "apiKey": "AIzaSyD_dnX9pgySDJaPPmFXY6tgIwyHIdabj90"
  };

  static Future<void> initConfig() async {
    try {
      await _config.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 15),
          minimumFetchInterval: const Duration(hours: 1)));

      //det default values
      await _config.setDefaults(_defaultValues);
      //fetch remote values
      await _config.fetch();
      await Future.delayed(const Duration(minutes: 10));
      await _config.activate();
      log('Remote Config Data: ${_config.getString('apiKey')}');
//activate remote values
      // _config.onConfigUpdated.listen(
      //   (event) async {
      //     await _config.activate();
      //     log('Updated: ${_config.getString('apiUrl')}');
      //   },
      //   onError: (final e) {
      //     // Ignore RC errors
      //   },
      // );
    } on SocketException catch (error) {
      log("Socket Exception occured************* $error");
    } on PlatformException catch (exception) {
      log("platform Exception occured************* $exception");
    } catch (e) {
      log("got some error $e");
      await _config.setDefaults(_defaultValues);
      log('default Config Data: ${_config.getString('apiKey')}');
    }
  }

  static String get apiKey => _config.getString('apiKey');
  static String get apiUrl => _config.getString('apiUrl'); //ad ids
}
