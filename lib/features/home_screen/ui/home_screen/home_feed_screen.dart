import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/feed_screen.dart';
import 'package:ysr_project/features/home_screen/widgets/multi_level_progress_widgets.dart';

class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ref.watch(futurePointsProvider).when(
              loading: () => Skeletonizer(
                enabled: true,
                child: MultiLevelProgressWidget(
                  progress: 100,
                  progressColor: Colors.grey,
                ),
              ),
              data: (data) => MultiLevelProgressWidget(
                progress: data.totalPoints!.toDouble(),
              ),
              error: (_, __) => SizedBox.shrink(),
            ),
        HomeFeedList()
      ],
    );
  }

  Future<void> downloadMultipleFiles(List<String> urls) async {
    final dio = Dio();
    // Request storage permission (needed for Android)
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Storage permission denied!");
        return;
      }
    }

    Directory? directory = await getDownloadDirectory();

    for (String url in urls) {
      String fileName = url.split('/').last;
      String filePath = "${directory?.path}/$fileName";

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
        print("Downloaded: $filePath");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error downloading $fileName: $e"),
          ),
        );

        print("Error downloading $fileName: $e");
      }
    }
  }

  Future<Directory?> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Use the public "Download" folder on Android
      return Directory('/storage/emulated/0/Download/');
    } else if (Platform.isIOS) {
      // Use the app's Documents directory on iOS
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }
}
