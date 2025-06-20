import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/helper_class/file_share_helper.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_feed_screen.dart';
import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';
import 'package:ysr_project/features/home_screen/widgets/build_platform_icons.dart';
import 'package:ysr_project/features/home_screen/widgets/comment_widget.dart';
import 'package:ysr_project/features/home_screen/widgets/media_carousel.dart';
import 'package:ysr_project/features/saved/providers/saved_posts_repository.dart';
import 'package:ysr_project/main.dart';
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
  String description = "";
  List<String> links = [];
  List<String> hashTags = [];
  String _currentUrl = "";

  @override
  void initState() {
    super.initState();
    updateDescriptionAndLink();
  }

  Widget buildLinks(List<String> links) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        children: links
            .map((e) => GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(e);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(e,
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)),
                ))
            .toList(),
      ),
    );
  }

  Widget buildHashTags(List<String> hashTags) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: hashTags
            .map((e) => GestureDetector(
                  onTap: () async {
                    final hashtag = e.replaceAll("#", "");
                    final Uri url =
                        Uri.parse("https://twitter.com/hashtag/$hashtag");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                      );
                    }
                  },
                  child: Text(e,
                      style: const TextStyle(color: AppColors.primaryColor)),
                ))
            .toList(),
      ),
    );
  }

  void updateDescriptionAndLink() {
    String value = widget.item.description ?? "";
    value = value.replaceAll("\n", " ");
    value = value.replaceAll("\r", " ");

    while (value.contains("#")) {
      int index = value.indexOf("#");
      String temp = value.substring(index);
      String hashTag = temp.split(" ").first;
      hashTags.add(hashTag);
      value = value.replaceAll(hashTag, "");
    }

    while (value.contains("https")) {
      int index = value.indexOf("https");
      String temp = value.substring(index);
      String url = temp.split(" ").first;
      links.add(url);
      value = value.replaceAll(url, "");
    }
    description = replaceBrWithNewLine(value);
  }

  String replaceBrWithNewLine(String input) {
    // Replace multiple <br> tags with a single new line
    String formatted = input.replaceAll(RegExp(r'(<br\s*/?>\s*)+'), '\n\n');

    // Trim any extra new lines at the start and end
    return formatted.trim();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(languageProvider);
    final userData = ref.watch(userProvider);
    final notifier = ref.read(homeFeedNotifierProvider.notifier);

    return Stack(
      children: [
        Container(
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
                      backgroundImage: AssetImage(
                          "assets/ysrcp_logo3.png"), // Change as needed
                      radius: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "WeYSRCP",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 11),
                        ),
                        Text(
                          DateFormat("MMMM d, y")
                              .format(widget.item.postedDate),
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Spacer(),
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
                                        width: 250,
                                        child: Column(
                                          children: [
                                            Row(children: [
                                              buildExpanded("Actions", 2),
                                              Gap(3),
                                              buildExpanded("Points", 1),
                                            ]),
                                            Gap(10),
                                            ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, item) {
                                                final point = data[item];
                                                final iconData =
                                                    SocialMediaIcons
                                                        .getIconData(point
                                                            .actionType
                                                            .toLowerCase());

                                                return ListTile(
                                                  leading: Icon(iconData),
                                                  title: Text(point.actionType),
                                                  trailing: Text(
                                                    point.points.toString(),
                                                    style:
                                                        TextStyle(fontSize: 13),
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
                              MdiIcons.informationSlabCircle,
                              color: AppColors.primaryColor,
                            )),
                      ),
                    ]
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (hashTags.isNotEmpty) buildHashTags(hashTags),
              if (links.isNotEmpty) buildLinks(links),
              SizedBox(height: 10),
              Container(
                child: widget.isVideo
                    ? MediaCarousel(
                        onUrlChanged: (url) {
                          setState(() {
                            _currentUrl = url;
                          });
                        },
                        mediaUrls:
                            widget.item.media.map((e) => e.fileUrl).toList())
                    : MediaCarousel(
                        onUrlChanged: (url) {
                          setState(() {
                            _currentUrl = url;
                          });
                        },
                        mediaUrls:
                            widget.item.media.map((e) => e.fileUrl).toList()),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PostActionsBar(
                    isSaved: widget.item.isSaved,
                    isLiked: widget.item.likedUsers.contains(userData.userId),
                    likeCount: widget.item.likeCount,
                    commentCount: widget.item.comments.length,
                    shareCount: widget.item.shareCount,
                    onLike: () {
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
                          // ref.invalidate(futurePointsProvider);
                        } else {}
                      }, onError: (error, stackTrace) {}).whenComplete(() {});
                    },
                    onComment: () {
                      showModalBottomSheet(
                        enableDrag: true,
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            CommentsBottomSheet(id: widget.index),
                      );
                    },
                    onShare: () async {
                      EasyLoading.show();
                      ref
                          .read(homeFeedRepoProvider)
                          .postAction(
                              action: "share",
                              batchId: widget.item.batchId,
                              userName: userData.name,
                              commentText: "",
                              shareType: "whatsapp")
                          .then((value) async {
                        EasyLoading.dismiss();
                        if (value) {
                          await shareFiles();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "You have reached the maximum share limit for this post(10 times)"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          await shareFiles();
                        }
                      }, onError: (error, stackTrace) async {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                        await shareFiles();
                      }).whenComplete(() {
                        EasyLoading.dismiss();
                      });
                    },
                    onBookmark: () async {
                      final userData = ref.read(userProvider);
                      notifier.toggleSave(widget.index);
                      ref
                          .read(homeFeedRepoProvider)
                          .postAction(
                              action: "save",
                              batchId: widget.item.batchId,
                              userName: userData.name,
                              commentText: "",
                              shareType: "")
                          .then((value) {
                        EasyLoading.dismiss();
                        if (value) {
                          // ref.invalidate(futurePointsProvider);
                        } else {}
                      }, onError: (error, stackTrace) {}).whenComplete(() {});
                      // await HelperDownloadFiles.downloadMultipleFiles(
                      //     widget.item.media.map((e) => e.fileUrl).toList(),
                      //     context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
        if (widget.item.pinnedPost)
        Image.asset(
          "assets/pin.png",
          width: 20,
          height: 20,
        ),
      ],
    );
  }

  Future<void> shareFiles() async {
    List<String> urls = [];
    for (var element in widget.item.media) {
      urls.add(element.fileUrl);
    }
    await FileShareHelper().shareFiles(urls,
        "$description${links.isNotEmpty ? "\n$links" : ""}${hashTags.isNotEmpty ? "\n$hashTags" : ""}");
    // ref.invalidate(futurePointsProvider);
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

class PostActionsBar extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onBookmark;

  const PostActionsBar({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onBookmark,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 250,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAction(
            icon: isLiked
                ? Image.asset("assets/like_icon.png", width: 18, height: 18)
                : Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 18,
                  ),
            label: '$likeCount',
            onTap: onLike,
          ),
          _buildAction(
            icon: Image.asset("assets/chat_icon.png", width: 18, height: 18),
            label: commentCount.toString(),
            onTap: onComment,
          ),
          _buildAction(
            icon: Image.asset(
              "assets/send_icon.png",
              width: 18,
              height: 18,
            ),
            label: shareCount.toString(),
            onTap: onShare,
          ),
          IconButton(padding: EdgeInsets.zero,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.blueAccent,
              size: 20,
            ),
            onPressed: onBookmark,
          )
        ],
      ),
    );
  }

  Widget _buildAction({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
