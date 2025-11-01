import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/feed_screen.dart';
import 'package:ysr_project/features/influencer/story_feed_screen.dart';
import 'package:ysr_project/features/notifications/presentation/ui/notifications_screen.dart';
import 'package:ysr_project/features/profile/ui/user_profile_ui.dart';
import 'package:ysr_project/features/saved/saved.dart';
import 'package:ysr_project/services/user/user_data.dart';

final isLatestFeedSelected = StateProvider<bool>((ref) => true);

class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: YsrAppBar(
          leading: Image.asset(
            "assets/image_2.png",
            width: 45,
            height: 45,
          ),
          title: Text(
            "Welcome ${ref.watch(userProvider).name}",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()),
                );
              },
              child: Image.asset(
                "assets/notifications.png",
                width: 25,
                height: 25,
              ),
            ),
            Gap(5),
            GestureDetector(
              onTap: () {
                final phNumber = ref.read(userProvider).mobile;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => UserProfileUI(phNumber)),
                );
              },
              child: Image.asset(
                "assets/profile.png",
                width: 35,
                height: 35,
              ),
            ),
            Gap(5),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: StoryFeedScreen(),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: 10,
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           ref.read(isLatestFeedSelected.notifier).state = true;
            //           ref.invalidate(homeFeedNotifierProvider);
            //         },
            //         child: Container(
            //           padding:
            //               EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            //           decoration: BoxDecoration(
            //             color: ref.watch(isLatestFeedSelected)
            //                 ? AppColors.primaryColor
            //                 : Colors.transparent,
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           alignment: Alignment.center,
            //           child: Text(
            //             "Latest",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 12,
            //                 color: ref.watch(isLatestFeedSelected)
            //                     ? Colors.white
            //                     : Colors.black),
            //           ),
            //         ),
            //       ),
            //       Gap(10),
            //       GestureDetector(
            //         onTap: () {
            //           ref.read(isLatestFeedSelected.notifier).state = false;
            //         },
            //         child: Container(
            //           padding:
            //               EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //           decoration: BoxDecoration(
            //             color: ref.watch(isLatestFeedSelected)
            //                 ? Colors.transparent
            //                 : AppColors.primaryColor,
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           alignment: Alignment.center,
            //           child: Text(
            //             "Saved",
            //             style: TextStyle(
            //                 fontSize: 12,
            //                 fontWeight: FontWeight.bold,
            //                 color: ref.watch(isLatestFeedSelected)
            //                     ? Colors.black
            //                     : Colors.white),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            ref.watch(isLatestFeedSelected)
                ? Expanded(child: HomeFeedList())
                : Expanded(child: SavedPostsScreen())
          ],
        ));
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
