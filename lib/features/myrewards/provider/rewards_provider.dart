import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';
import '../data/models/rewards_response_model.dart';
import '../data/repository/rewards_repository.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return RewardsRepository(dio: dio, ref: ref);
});

final rewardsFutureProvider =
    FutureProvider.autoDispose<RewardsResponseModel>((ref) async {
  final repository = ref.read(rewardsRepositoryProvider);
  final userId =
      ref.read(userProvider).userId; // Assuming you have a userProvider
  return repository.getUserRewards(userId);
});
