import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/repository/home_feeds_repo_impl.dart';
import 'package:ysr_project/features/home_screen/response_model/grievance_categories_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/grievance_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/influencer_video_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/notification_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/pdf_files_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/special_points.dart';
import 'package:ysr_project/features/home_screen/response_model/special_videos.dart';
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
    FutureProvider.autoDispose<UserPointsResponseModel>((ref) async {
  return ref.read(homeFeedRepoProvider).getUserPoints();
});

final futureGrievancesProvider =
    FutureProvider.autoDispose<List<Grievance>>((ref) async {
  return ref.read(homeFeedRepoProvider).getGrievances();
});

final futurePointsForBatchIdProvider =
    FutureProvider.family<List<SpecialPoints>, String>((ref, batchId) async {
  return ref.read(homeFeedRepoProvider).getUserPointsForBatchId(batchId);
});
final asyncUrlProvider = FutureProvider<String>((ref) async {
  return ref.read(homeFeedRepoProvider).getUrl();
});

final specialVideoProvider =
    FutureProvider.autoDispose<List<SpecialVideos>>((ref) async {
  return ref.read(homeFeedRepoProvider).getSpecialVideos();
});

final influencerVideoProvider =
    FutureProvider.autoDispose<List<InfluencerVideoResponseModel>>((ref) async {
  return ref.read(homeFeedRepoProvider).getInfluencerVideos();
});

final pdfFilesProvider =
    FutureProvider.autoDispose<List<PdfFilesResponseModel>>((ref) async {
  return ref.read(homeFeedRepoProvider).getPdfFiles();
});

final grievanceCategoriesProvider =
    FutureProvider.autoDispose<List<GrievanceCategoryResponseModel>>(
        (ref) async {
  return ref.read(homeFeedRepoProvider).grievanceCategories();
});
