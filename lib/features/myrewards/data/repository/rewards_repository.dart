import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/rewards_response_model.dart';

class RewardsRepository {
  final Dio dio;
  final Ref ref;

  RewardsRepository({required this.dio, required this.ref});

  Future<RewardsResponseModel> getUserRewards(int userId) async {
    try {
      final response = await dio.get(
        '/user/completed-levels/$userId',
      );

      if (response.statusCode == 200) {
        return RewardsResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load rewards data');
      }
    } catch (e) {
      throw Exception('Error fetching rewards data: $e');
    }
  }
}
