import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ysr_project/permissions/android_permissions.dart';

class HelperDownloadFiles {
  static Future<void> downloadMultipleFiles(
      List<String> urls, BuildContext context) async {
    final dio = Dio();

    // Request storage permission (needed for Android)

    if (Platform.isAndroid) {
      if (!await AndroidPermission.requestPermissions()) {
        log("Permissions not granted");
        return;
      }
    } else if (Platform.isIOS) {
      downloadMultipleFilesForIos(urls, context);
    }

    // Define the directory to save files (Gallery folder)
    final directory = Directory('/storage/emulated/0/Pictures');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    for (String url in urls) {
      String fileType = url.split('.').last;
      String fileName = '${_generateUuid()}.$fileType';
      String filePath = "${directory.path}/$fileName";

      try {
        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            EasyLoading.showProgress(received / total);
            if (total != -1) {
              print(
                  "$fileName: ${(received / total * 100).toStringAsFixed(2)}% downloaded");
            }
          },
        );

        EasyLoading.dismiss();
        print("✅ Downloaded: $filePath");

        // Refresh gallery
        await refreshGallery(filePath);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error downloading $fileName: $e"),
          ),
        );

        print("❌ Error downloading $fileName: $e");
      }
    }
  }

  static Future<void> refreshGallery(String filePath) async {
    try {
      await _channel.invokeMethod('refreshGallery', {"filePath": filePath});
      print("✅ Gallery updated for $filePath");
    } catch (e) {
      print("❌ Error updating gallery: $e");
    }
  }

  static Future<void> downloadMultipleFilesForIos(
      List<String> urls, BuildContext context) async {
    final dio = Dio();

    // ✅ Get a writable directory based on the platform
    Directory directory;
    if (Platform.isIOS) {
      directory =
          await getApplicationDocumentsDirectory(); // iOS sandboxed directory
    } else {
      directory = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
    }

    final downloadDir = Directory("${directory.path}/Downloads");
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    for (String url in urls) {
      String fileName = url.split('/').last;
      String filePath = "${downloadDir.path}/$fileName";

      try {
        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            EasyLoading.showProgress(received / total);
            if (total != -1) {
              print(
                  "$fileName: ${(received / total * 100).toStringAsFixed(2)}% downloaded");
            }
          },
        );

        EasyLoading.dismiss();
        print("✅ Downloaded: $filePath");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error downloading $fileName: $e"),
          ),
        );

        print("❌ Error downloading $fileName: $e");
      }
    }
  }

  static String _generateUuid() {
    final uuid = Uuid();
    return uuid.v4();
  }
}

const MethodChannel _channel = MethodChannel('gallery_scanner');
