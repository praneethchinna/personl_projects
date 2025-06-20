import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/influencer/story_feed_model.dart';
import 'package:ysr_project/services/user/user_data.dart';

import 'influencer_providers.dart';
import 'influencer_video_list_screen.dart';

class StoryFeedScreen extends ConsumerWidget {
  const StoryFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userProvider).userId;
    final storyFeedAsync = ref.watch(storyFeedProvider(userId));

    return storyFeedAsync.when(
      data: (stories) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stories
              .map((story) => GestureDetector(
                    onTap: () async {
                      await ref.read(markViewedProvider(story.id).future);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InfluencerVideoListScreen(
                              story: story,
                              influencerId: story.id,
                              influencerName: story.influencerName,
                            ),
                          ));
                    },
                    child: StoryStatus(
                      story: story,
                    ),
                  ))
              .toList(),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => const Center(child: Text('Error loading stories')),
    );
  }
}

class StoryStatus extends StatelessWidget {
  final StoryFeed story;
  const StoryStatus({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 8, 4),
            padding:
                const EdgeInsets.all(4), // this creates the "border" effect
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: story.viewed
                    ? [Colors.grey, Colors.grey]
                    : [Color(0xFFF18C8C), Color(0xFF7D53D8)],
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
                    image: NetworkImage(story.channelProfilePic),
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
            overflow: TextOverflow.ellipsis,
            story.influencerName,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
