import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';

import 'special_video_player_screen.dart';
import 'special_videos_provider.dart';
import 'special_videos_response_model.dart';

class SpecialVideosUi extends ConsumerStatefulWidget {
  const SpecialVideosUi({super.key});

  @override
  ConsumerState<SpecialVideosUi> createState() => _SpecialVideosUiState();
}

class _SpecialVideosUiState extends ConsumerState<SpecialVideosUi> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(specialVideosPaginationProvider);
    if (state.isLoading && state.videos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.videos.isEmpty) {
      return Center(child: Text('Error: ${state.error}'));
    }
    if (state.videos.isEmpty) {
      return const Center(child: Text('No special videos found.'));
    }
    // Group videos by date
    final Map<String, List<SpecialVideo>> grouped = {};
    for (final video in state.videos) {
      final dateKey = _formatDate(video.createdTime);
      grouped.putIfAbsent(dateKey, () => []).add(video);
    }
    return Scaffold(
      appBar: YsrAppBar(
        title: Text(
          "Special Videos",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          ...grouped.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entry.value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, idx) {
                    final video = entry.value[idx];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SpecialVideoPlayerScreen(initialVideo: video),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  video.thumbnailUrl ?? "",
                                  width: double.infinity,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 110,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.play_circle,
                                          size: 40),
                                    );
                                  },
                                )),
                            Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                video.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
          if (state.isLoading && state.videos.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  String? _getYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    } else if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'];
    }
    return null;
  }
}
