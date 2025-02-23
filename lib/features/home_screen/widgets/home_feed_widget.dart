import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/helper/download_multiple_file.dart';
import 'package:ysr_project/features/home_screen/helper_class/file_share_helper.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';
import 'package:ysr_project/features/home_screen/widgets/build_platform_icons.dart';
import 'package:ysr_project/features/home_screen/widgets/comment_widget.dart';
import 'package:ysr_project/features/home_screen/widgets/media_carousel.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

class HomeFeedWidget extends ConsumerStatefulWidget {
  final HomeFeedViewModel item;
  final int index;
  final bool isVideo;
  final Iterable<int?> likedUsers;
  const HomeFeedWidget(
      {super.key,
      required this.item,
      required this.index,
      required this.isVideo,
      required this.likedUsers});

  @override
  ConsumerState<HomeFeedWidget> createState() => _HomeFeedWidgetState();
}

class _HomeFeedWidgetState extends ConsumerState<HomeFeedWidget> {
  final _controller = SuperTooltipController();
  String _currentUrl = "";

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final notifier = ref.read(homeFeedNotifierProvider.notifier);
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/image_2.png"), // Change as needed
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
                      DateFormat("MMMM d, y").format(widget.item.postedDate),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (widget.item.postType.toLowerCase() == "special") ...[
                  Gap(10),
                  Icon(
                    Icons.star,
                    color: AppColors.goldColor,
                  ),
                  Gap(10),
                  GestureDetector(
                    onTap: () async {
                      await _controller.showTooltip();
                    },
                    child: SuperTooltip(
                      showBarrier: true,
                      controller: _controller,
                      content: ref
                          .watch(futurePointsForBatchIdProvider(
                              widget.item.batchId))
                          .when(
                            data: (data) {
                              return SingleChildScrollView(
                                child: SizedBox(
                                  width: 300,
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        buildExpanded("Social Media", 2),
                                        Gap(3),
                                        buildExpanded("Points", 1),
                                      ]),
                                      Gap(10),
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, item) {
                                          final point = data[item];
                                          final iconData =
                                              SocialMediaIcons.getIconData(point
                                                  .actionType
                                                  .toLowerCase());

                                          return ListTile(
                                            leading: Icon(iconData),
                                            title: Text(point.actionType),
                                            trailing: Text(
                                              point.points.toString(),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          );
                                        },
                                        itemCount: data.length,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            error: (error, stack) {
                              return Text(error.toString());
                            },
                            loading: () => Skeletonizer(
                                child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text("testing tile"),
                                  trailing: CircleAvatar(radius: 10),
                                );
                              },
                              itemCount: 5,
                            )),
                          ),
                      child: Icon(
                        Icons.info,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          Container(
            child: widget.isVideo
                ? MediaCarousel(
                    onUrlChanged: (url) {
                      setState(() {
                        _currentUrl = url;
                      });
                    },
                    mediaUrls: widget.item.media.map((e) => e.fileUrl).toList())
                : MediaCarousel(
                    onUrlChanged: (url) {
                      setState(() {
                        _currentUrl = url;
                      });
                    },
                    mediaUrls:
                        widget.item.media.map((e) => e.fileUrl).toList()),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              widget.item.description,
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
                    notifier.toggleLike(widget.index);
                    final userData = ref.read(userProvider);
                    ref
                        .read(homeFeedRepoProvider)
                        .postAction(
                            action: "like",
                            batchId: widget.item.batchId,
                            userName: userData.name,
                            commentText: "",
                            shareType: "")
                        .then((value) {
                      EasyLoading.dismiss();
                      if (value) {
                        ref.invalidate(futurePointsProvider);
                      } else {}
                    }, onError: (error, stackTrace) {}).whenComplete(() {});
                  },
                  child: Container(
                    child: widget.item.likedUsers.contains(userData.userId)
                        ? Icon(
                            Boxicons.bxs_like,
                            color: AppColors.primaryColor,
                          )
                        : Icon(Boxicons.bx_like),
                  ),
                ),
                Gap(5),
                if (widget.item.likeCount == 0)
                  Text("Like")
                else
                  Text(widget.likedUsers.length.toString()),
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        enableDrag: true,
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            CommentsBottomSheet(id: widget.index),
                      );
                    },
                    child: _buildAction(
                        Icon(CommunityMaterialIcons.comment_outline),
                        "comment",
                        widget.item.comments.length.toString())),
                GestureDetector(
                    onTap: () async {
                      List<String> urls = [];
                      for (var element in widget.item.media) {
                        urls.add(element.fileUrl);
                      }
                      await FileShareHelper().shareFiles(urls);
                      ref
                          .read(homeFeedRepoProvider)
                          .postAction(
                              action: "share",
                              batchId: widget.item.batchId,
                              userName: userData.name,
                              commentText: "",
                              shareType: "whatsapp")
                          .then((value) {
                        EasyLoading.dismiss();
                        if (value) {
                          ref.invalidate(futurePointsProvider);
                        } else {}
                      }, onError: (error, stackTrace) {}).whenComplete(() {});
                    },
                    child: _buildAction(Icon(Boxicons.bx_share_alt), "share",
                        widget.item.shareCount.toString())),
                Spacer(),
                IconButton(
                  icon: Icon(Boxicons.bx_download),
                  onPressed: () async {
                    await HelperDownloadFiles.downloadMultipleFiles(
                        widget.item.media.map((e) => e.fileUrl).toList(),
                        context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Expanded buildExpanded(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(3)),
        alignment: Alignment.center,
        height: 30,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
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
