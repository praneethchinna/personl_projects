import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ysr_project/permissions/android_permissions.dart';

class FileShareHelper {
  final Dio dio = Dio();

  Future<void> shareFiles(List<String> urls, String? description) async {
    EasyLoading.show(status: "Downloading files...");

    if (!await AndroidPermission.requestPermissions()) {
      log("Permissions not granted");
      EasyLoading.dismiss();
      return;
    }

    Directory tempDir = await getTemporaryDirectory();
    List<XFile> imageFiles = [];
    List<XFile> videoFiles = [];

    for (String url in urls) {
      try {
        String filename = url.split('/').last;
        String savePath = '${tempDir.path}/$filename';
        File file = File(savePath);

        if (!await file.exists()) {
          Response response = await dio.download(url, savePath);
          if (response.statusCode == 200) {
            log("Download completed: $filename");
          } else {
            log("Download failed: $filename, Status: ${response.statusCode}");
            continue;
          }
        }

        // Ensure file is valid
        if (await file.exists() && await file.length() > 0) {
          if (filename.endsWith('.jpg') ||
              filename.endsWith('.jpeg') ||
              filename.endsWith('.png')) {
            imageFiles.add(XFile(savePath));
          } else if (filename.endsWith('.mp4') ||
              filename.endsWith('.mov') ||
              filename.endsWith('.avi')) {
            videoFiles.add(XFile(savePath));
          }
        } else {
          log("Invalid or empty file: $filename");
        }
      } catch (e) {
        log("Error downloading file: $e");
      }
    }

    EasyLoading.dismiss();

    // Share images first, then videos
    if (imageFiles.isNotEmpty) {
      List<String> imageUrls =
          imageFiles.map((e) => e.path.split('/').last).toList();
      await Share.shareXFiles(imageFiles,
          text:
              description ?? "Here are some images: ${imageUrls.join(', ')}!");
    }

    if (videoFiles.isNotEmpty) {
      List<String> videoUrls =
          videoFiles.map((e) => e.path.split('/').last).toList();
      await Share.shareXFiles(videoFiles,
          text:
              description ?? "Here are some videos: ${videoUrls.join(', ')}!");
    }

    if (imageFiles.isEmpty && videoFiles.isEmpty) {
      log("No valid files to share.");
    }
  }
}
