import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/response_model/home_feeds_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/notification_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/special_points.dart';
import 'package:ysr_project/features/home_screen/response_model/special_videos.dart';
import 'package:ysr_project/features/home_screen/response_model/user_points_response_model.dart';
import 'package:ysr_project/services/user/user_data.dart';

class HomeFeedsRepoImpl {
  final Dio dio;
  final Ref ref;

  HomeFeedsRepoImpl({required this.dio, required this.ref});

  Future<List<HomeFeedsResponseModel>> getHomeFeeds() async {
    try {
      final response = await dio.get('/uploads/homefeed');
      if (response.statusCode == 200) {
        return homeFeedsResponseModelFromJson(response.data);
      } else {
        return throw Exception("Failed to fetch Home Feeds");
      }
    } catch (e) {
      return throw Exception("Failed to fetch Home Feeds");
    }
  }

  Future<UserPointsResponseModel> getUserPoints() async {
    try {
      final userId = ref.read(userProvider).userId;
      final response = await dio.get('/user/points/$userId');
      if (response.statusCode == 200) {
        return UserPointsResponseModel.fromJson(response.data);
      } else {
        return throw Exception("Failed to fetch User Points");
      }
    } catch (e) {
      return throw Exception("Failed to fetch User Points");
    }
  }

  Future<bool> postAction({
    required String action,
    required String batchId,
    required String userName,
    required String commentText,
    required String shareType,
  }) async {
    try {
      final userId = ref.read(userProvider).userId;
      final response = await dio.post('/post/action', data: {
        'action': action,
        'batch_id': batchId,
        'user_id': userId,
        'user_name': userName,
        'comment_text': commentText,
        'share_type': shareType,
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to post action");
      }
    } catch (e) {
      throw Exception("Failed to post action");
    }
  }

  Future<NotificationResponseModel> getLatestVideos() async {
    try {
      final response = await dio.get('/check_videos');
      if (response.statusCode == 200) {
        return NotificationResponseModel.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch Latest Videos");
      }
    } catch (e) {
      throw Exception("Failed to fetch Latest Videos");
    }
  }

  Future<List<SpecialPoints>> getUserPointsForBatchId(String batchId) async {
    try {
      final response = await dio.get('/special_points/$batchId');
      if (response.statusCode == 200) {
        final listOfPoints = response.data as List;
        return listOfPoints
            .map((element) => SpecialPoints.fromJson(element))
            .toList();
      } else {
        throw Exception("Failed to fetch User Points for Batch Id");
      }
    } catch (e) {
      throw Exception("Failed to fetch User Points for Batch Id");
    }
  }

  Future<String> getUrl() async {
    try {
      final response = await dio.get('/live-videos');
      if (response.statusCode == 200) {
        return response.data['video_url'];
      }
      throw Exception("Failed to fetch url");
    } catch (e) {
      throw Exception("Failed to fetch url");
    }
  }

  Future<List<SpecialVideos>> getSpecialVideos() async {
    try {
      final response = await dio.get('/special-videos');
      if (response.statusCode == 200) {
        final listOfVideos = response.data as List;
        return listOfVideos
            .map((element) => SpecialVideos.fromJson(element))
            .toList();
      } else {
        throw Exception("Failed to fetch Special Videos");
      }
    } catch (e) {
      throw Exception("Failed to fetch Special Videos");
    }
  }
}
