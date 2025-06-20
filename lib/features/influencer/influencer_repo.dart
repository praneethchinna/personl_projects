import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/services/user/user_data.dart';

import 'influencer_video_model.dart';
import 'story_feed_model.dart';

class InfluencerRepo {
  final Dio dio;
  final Ref ref;

  InfluencerRepo({required this.dio, required this.ref});

  Future<List<StoryFeed>> getStoryFeed({required int userId}) async {
    final response = await dio.get('/youtube-influencers/story-feed',
        queryParameters: {'user_id': userId});
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => StoryFeed.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch story feed');
    }
  }

  Future<void> markViewed(int influencerId) async {
    final response = await dio.post(
        '/youtube-influencers/$influencerId/mark-viewed?user_id=${ref.read(userProvider).userId}');
    if (response.statusCode != 200) {
      throw Exception('Failed to mark as viewed');
    }
  }

  Future<InfluencerVideoPaginatedResponse> getInfluencerVideos(int influencerId,
      {int page = 1}) async {
    final response = await dio
        .get('/youtube-videos/$influencerId', queryParameters: {'page': page});
    if (response.statusCode == 200) {
      return InfluencerVideoPaginatedResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch influencer videos');
    }
  }
}
