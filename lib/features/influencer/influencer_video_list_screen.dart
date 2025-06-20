import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loadmore/loadmore.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/influencer/story_feed_model.dart';
import 'package:ysr_project/features/influencer/story_feed_screen.dart';
import 'package:ysr_project/services/user/user_data.dart';

import 'influencer_providers.dart';
import 'influencer_video_model.dart';
import 'video_detail_screen.dart';

class InfluencerVideoListScreen extends ConsumerStatefulWidget {
  final int influencerId;
  final String influencerName;
  final StoryFeed story;

  const InfluencerVideoListScreen({
    super.key,
    required this.influencerId,
    required this.influencerName,
    required this.story,
  });

  @override
  ConsumerState<InfluencerVideoListScreen> createState() =>
      _InfluencerVideoListScreenState();
}

class _InfluencerVideoListScreenState
    extends ConsumerState<InfluencerVideoListScreen> {
  List<InfluencerVideo> _videos = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos({bool loadMore = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final req = InfluencerVideosRequest(
      influencerId: widget.influencerId,
      page: _currentPage,
    );
    final response = await ref.read(influencerVideosProvider(req).future);

    setState(() {
      _totalPages = response.totalPages;
      if (loadMore) {
        _videos.addAll(response.videos);
      } else {
        _videos = response.videos;
      }
      _isLoading = false;
    });
  }

  Future<bool> _onLoadMore() async {
    if (_currentPage < _totalPages) {
      _currentPage++;
      await _fetchVideos(loadMore: true);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        ref.invalidate(storyFeedProvider(ref.read(userProvider).userId));
      },
      child: Scaffold(
        appBar: YsrAppBar(
          title: Text(
            "Influencer Videos",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 12, 8, 4),
                    padding: const EdgeInsets.all(
                        4), // this creates the "border" effect
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFF18C8C), Color(0xFF7D53D8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white, // inner background
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(widget.story.channelProfilePic),
                            onError: (_, __) => const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.story.influencerName,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LoadMore(
                isFinish: _currentPage >= _totalPages,
                onLoadMore: _onLoadMore,
                textBuilder: DefaultLoadMoreTextBuilder.english,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    final videoId =
                        Uri.parse(video.videoUrl).queryParameters['v'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoDetailScreen(
                              video: video,
                              allVideos: _videos,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://img.youtube.com/vi/$videoId/0.jpg',
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator.adaptive(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    height: 180,
                                    width: double.infinity,
                                    child: Icon(Icons.broken_image,
                                        size: 48, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.videoTitle,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                  Gap(10),
                                  Text(
                                    DateFormat('MMMM d, yyyy')
                                        .format(video.publishedAt),
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
