import 'dart:developer';
import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/helper/download_multiple_file.dart';
import 'package:ysr_project/features/home_screen/helper_class/file_share_helper.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
import 'package:ysr_project/features/home_screen/widgets/comment_widget.dart';
import 'package:ysr_project/features/home_screen/widgets/media_carousel.dart';
import 'package:ysr_project/permissions/android_permissions.dart';
import 'package:ysr_project/services/user/user_data.dart';

class HomeFeedList extends ConsumerStatefulWidget {
  const HomeFeedList({super.key});

  @override
  _HomeFeedListState createState() => _HomeFeedListState();
}

class _HomeFeedListState extends ConsumerState<HomeFeedList> {
  String _currentUrl = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeFeedNotifierProvider);
    final userData = ref.watch(userProvider);
    final notifier = ref.read(homeFeedNotifierProvider.notifier);
    return switch (true) {
      _ when viewModel.isLoading =>
        Expanded(child: Center(child: CircularProgressIndicator.adaptive())),
      _ when viewModel.isError => Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sorry Something went wrong"),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(homeFeedNotifierProvider);
                    ref.invalidate(futurePointsProvider);
                  },
                  child: Text("Refresh"),
                )
              ],
            ),
          ),
        ),
      _ => Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              ref.invalidate(homeFeedNotifierProvider);
            },
            child: ListView.separated(
              itemCount: viewModel.homeFeedViewModels.length,
              padding: EdgeInsets.all(10),
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = viewModel.homeFeedViewModels[index];
                bool isVideo = item.media.first.fileType.contains("video");

                _currentUrl = item.media.first.fileUrl;
                final likedUsers =
                    item.likedUsers.where((element) => element != null);

                return Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/image_2.png"), // Change as needed
                              radius: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "WeYSRCP",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat("MMMM d, y")
                                      .format(item.postedDate),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: isVideo
                            ? MediaCarousel(
                                onUrlChanged: (url) {
                                  setState(() {
                                    _currentUrl = url;
                                  });
                                },
                                mediaUrls:
                                    item.media.map((e) => e.fileUrl).toList())
                            : MediaCarousel(
                                onUrlChanged: (url) {
                                  setState(() {
                                    _currentUrl = url;
                                  });
                                },
                                mediaUrls:
                                    item.media.map((e) => e.fileUrl).toList()),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Divider(
                        endIndent: 10,
                        indent: 10,
                        color: Colors.grey.shade300,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                notifier.toggleLike(index);
                                final userData = ref.read(userProvider);
                                ref
                                    .read(homeFeedRepoProvider)
                                    .postAction(
                                        action: "like",
                                        batchId: item.batchId,
                                        userName: userData.name,
                                        commentText: "",
                                        shareType: "")
                                    .then((value) {
                                  EasyLoading.dismiss();
                                  if (value) {
                                    ref.invalidate(futurePointsProvider);
                                  } else {}
                                },
                                        onError: (error,
                                            stackTrace) {}).whenComplete(() {});
                              },
                              child: Container(
                                child: item.likedUsers.contains(userData.userId)
                                    ? Icon(
                                        Boxicons.bxs_like,
                                        color: AppColors.primaryColor,
                                      )
                                    : Icon(Boxicons.bx_like),
                              ),
                            ),
                            Gap(5),
                            if (item.likeCount == 0)
                              Text("Like")
                            else
                              Text(likedUsers.length.toString()),
                            GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    enableDrag: true,
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        CommentsBottomSheet(id: index),
                                  );
                                },
                                child: _buildAction(
                                    Icon(
                                        CommunityMaterialIcons.comment_outline),
                                    "comment",
                                    item.comments.length.toString())),
                            GestureDetector(
                                onTap: () async {
                                  List<String> urls = [];
                                  item.media.forEach((element) {
                                    urls.add(element.fileUrl);
                                  });
                                  await FileShareHelper().shareFiles(urls);
                                  ref
                                      .read(homeFeedRepoProvider)
                                      .postAction(
                                          action: "share",
                                          batchId: item.batchId,
                                          userName: userData.name,
                                          commentText: "",
                                          shareType: "whatsapp")
                                      .then((value) {
                                    EasyLoading.dismiss();
                                    if (value) {
                                      ref.invalidate(futurePointsProvider);
                                    } else {}
                                  },
                                          onError: (error,
                                              stackTrace) {}).whenComplete(
                                          () {});
                                },
                                child: _buildAction(Icon(Boxicons.bx_share_alt),
                                    "share", item.shareCount.toString())),
                            Spacer(),
                            IconButton(
                              icon: Icon(Boxicons.bx_download),
                              onPressed: () async {
                                await HelperDownloadFiles.downloadMultipleFiles(
                                    item.media.map((e) => e.fileUrl).toList(),
                                    context);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        )
    };
  }

  Widget _buildAction(Icon icon, String label, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [icon, Gap(5), Text(label), Gap(5), Text(count)],
      ),
    );
  }
}
