import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/repository/home_feeds_repo_impl.dart';
import 'package:ysr_project/features/home_screen/response_model/notification_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/user_points_response_model.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

final homeFeedRepoProvider = Provider<HomeFeedsRepoImpl>((ref) {
  final dio = ref.read(dioProvider);
  return HomeFeedsRepoImpl(dio: dio, ref: ref);
});

final futureNotificatonProvider =
    FutureProvider<NotificationResponseModel>((ref) async {
  return ref.read(homeFeedRepoProvider).getLatestVideos();
});

final futurePointsProvider =
    FutureProvider<UserPointsResponseModel>((ref) async {
  return ref.read(homeFeedRepoProvider).getUserPoints();
});
