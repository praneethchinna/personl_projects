import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

import 'influencer_repo.dart';
import 'influencer_video_model.dart';
import 'story_feed_model.dart';

final influencerRepoProvider = Provider<InfluencerRepo>((ref) {
  final dio = ref.read(dioProvider);
  return InfluencerRepo(dio: dio, ref: ref);
});

final storyFeedProvider =
    FutureProvider.family<List<StoryFeed>, int>((ref, userId) async {
  return ref.read(influencerRepoProvider).getStoryFeed(userId: userId);
});

class InfluencerVideosRequest {
  final int influencerId;
  final int page;
  InfluencerVideosRequest({required this.influencerId, required this.page});
}

final influencerVideosProvider = FutureProvider.family
    .autoDispose<InfluencerVideoPaginatedResponse, InfluencerVideosRequest>(
        (ref, req) async {
  return ref
      .read(influencerRepoProvider)
      .getInfluencerVideos(req.influencerId, page: req.page);
});

final markViewedProvider =
    FutureProvider.family.autoDispose<void, int>((ref, influencerId) async {
  return ref.read(influencerRepoProvider).markViewed(influencerId);
});
