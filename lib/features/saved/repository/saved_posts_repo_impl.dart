import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/response_model/home_feeds_response_model.dart';
import 'package:ysr_project/services/user/user_data.dart';

class SavedPostsRepoImpl {
  final Dio dio;
  final Ref ref;

  SavedPostsRepoImpl({required this.dio, required this.ref});

  Future<List<HomeFeedsResponseModel>> getSavedPosts({int page = 1}) async {
    try {
      final userId = ref.read(userProvider).userId;
      final response = await dio.get('/uploads/savedposts?user_id=$userId');

      if (response.statusCode == 200) {
        final data = response.data["saved_posts"] as List;

        return data.map((e) => HomeFeedsResponseModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch saved posts");
      }
    } catch (e) {
      throw Exception("Failed to fetch saved posts: $e");
    }
  }
}
