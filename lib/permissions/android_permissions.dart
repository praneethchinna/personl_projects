import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class AndroidPermission {
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // For Android 13 (API level 33) and above
      if (await Permission.photos.request().isGranted &&
          await Permission.mediaLibrary.request().isGranted) {
        return true;
      }
      // For Android 12 and below
      if (await Permission.storage.request().isGranted) {
        return true;
      }
    }
    return true;
  }
}
