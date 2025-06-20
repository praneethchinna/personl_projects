import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';
import 'package:ysr_project/features/widget/reusable_youtube_player.dart';

import 'influencer_video_model.dart';

class VideoDetailScreen extends StatefulWidget {
  final InfluencerVideo video;
  final List<InfluencerVideo> allVideos;

  const VideoDetailScreen({
    super.key,
    required this.video,
    required this.allVideos,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late InfluencerVideo _currentVideo;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentVideo = widget.video;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          "share".tr(), // Use .tr() for localization
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = widget.allVideos
        .where((v) => v.videoId != _currentVideo.videoId)
        .toList();

    // No need to calculate availableHeight this way if using SingleChildScrollView for the entire body
    // The SingleChildScrollView will handle the scrolling based on content size.

    return ReusableYouTubePlayer(
        key: UniqueKey(),
        appBarTitle: "Influencer Videos",
        initialVideoId: _currentVideo.videoUrl.split('=').last,
        body: _buildContent(suggestions));
  }

  Widget _buildContent(List<InfluencerVideo> suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            _currentVideo.videoTitle,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Video Date
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            DateFormat('MMMM d, yyyy').format(_currentVideo.publishedAt),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Action Buttons Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // You had "3 Hours ago" hardcoded, consider replacing with a dynamic value if available
              Text(
                "3 Hours ago", // Placeholder
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  ShareCard(
                          title: _currentVideo.videoTitle,
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
                          title: _currentVideo.videoTitle,
                          link: _currentVideo.videoUrl)
                      .shareOnSocialMedia(context, "share".tr()),
                  "generic"),
            ],
          ),
        ),
        Gap(10), // Add some spacing

        // Suggested Videos Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Suggested Videos',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ),

        // Suggested Videos List
        // When ListView.builder is inside a SingleChildScrollView, it needs a defined height.
        // You can use a fixed height or a LayoutBuilder to calculate remaining space.
        // For simplicity here, we'll use a fixed height or expanded based on orientation if it's the only scrollable.
        // Since the whole column is scrollable, it's safer to give it a sensible height to prevent infinite height issues.
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap:
              true, // Important: Makes ListView only occupy space needed by its children
          physics:
              const NeverScrollableScrollPhysics(), // Important: Disable its own scrolling
          itemCount: suggestions.length,
          itemBuilder: (context, idx) => _buildSuggestionItem(suggestions[idx]),
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(InfluencerVideo v) {
    final suggestionId = v.videoUrl.split('=').last;
    final thumbnailUrl =
        'https://img.youtube.com/vi/$suggestionId/hqdefault.jpg';

    return GestureDetector(
      onTap: () {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        setState(() {
          _currentVideo = v;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                thumbnailUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    height: 70,
                    width: 110,
                    child:
                        Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  );
                },
                height: 70,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.videoTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  // Removed redundant SizedBox(height: 4)
                  Text(
                    DateFormat('MMMM d, yyyy') // Use 'yyyy' for year
                        .format(v
                            .publishedAt), // Use v.publishedAt for the specific video
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
