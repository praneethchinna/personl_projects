import 'package:dio/dio.dart';

import 'special_videos_response_model.dart';

class SpecialVideosRepo {
  final Dio dio;
  SpecialVideosRepo({required this.dio});

  Future<SpecialVideosResponseModel> getSpecialVideos({int page = 1}) async {
    try {
      final response = await dio.get('/special-videos-mobile?page=$page');
      return SpecialVideosResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch special videos: $e');
    }
  }
}
