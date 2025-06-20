import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';
import 'package:ysr_project/features/widget/reusable_youtube_player.dart';

import 'special_videos_provider.dart';
import 'special_videos_response_model.dart';

class SpecialVideoPlayerScreen extends ConsumerStatefulWidget {
  final SpecialVideo initialVideo;
  const SpecialVideoPlayerScreen({super.key, required this.initialVideo});

  @override
  ConsumerState<SpecialVideoPlayerScreen> createState() =>
      _SpecialVideoPlayerScreenState();
}

class _SpecialVideoPlayerScreenState
    extends ConsumerState<SpecialVideoPlayerScreen> {
  late SpecialVideo _currentVideo;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentVideo = widget.initialVideo;

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(specialVideosPaginationProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        state.hasNext &&
        !state.isLoading) {
      ref.read(specialVideosPaginationProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(specialVideosPaginationProvider);
    return ReusableYouTubePlayer(
      appBarTitle: "Special Videos",
      key: UniqueKey(),
      initialVideoId: _currentVideo.videoUrl.split('=').last,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              _currentVideo.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _currentVideo.description,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  "3 Hours ago",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    ShareCard(
                            title: _currentVideo.title,
                            link: _currentVideo.videoUrl)
                        .launchURL(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/youtube.png",
                        width: 22,
                        height: 22,
                      ),
                      Gap(5),
                      Text(
                        "watch_now".tr(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _socialButton(
                    Icons.share,
                    Colors.black54,
                    () => ShareCard(
                            title: _currentVideo.title,
                            link: _currentVideo.videoUrl)
                        .shareOnSocialMedia(context, "share".tr()),
                    "generic"),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suggested Videos from Sakshi',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.videos.length + (state.isLoading ? 1 : 0),
            itemBuilder: (context, idx) {
              if (idx >= state.videos.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final video = state.videos[idx];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentVideo = video;
                  });
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            video.thumbnailUrl ?? "",
                            width: 110,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 110,
                                height: 70,
                                color: Colors.grey[300],
                                child: const Icon(Icons.play_circle, size: 40),
                              );
                            },
                          )),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              video.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getTimeAgo(video.createdTime),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _socialButton(
      IconData icon, Color color, VoidCallback onTap, String data) {
    return Row(
      children: [
        IconButton(
          onPressed: onTap,
          icon: FaIcon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        Text(
          "share",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  String _getTimeAgo(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays > 0) {
        return "${diff.inDays} Day${diff.inDays > 1 ? 's' : ''} ago";
      } else if (diff.inHours > 0) {
        return "${diff.inHours} Hour${diff.inHours > 1 ? 's' : ''} ago";
      } else if (diff.inMinutes > 0) {
        return "${diff.inMinutes} min ago";
      } else {
        return "Just now";
      }
    } catch (_) {
      return isoDate;
    }
  }
}
