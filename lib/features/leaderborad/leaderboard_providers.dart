import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_notifier.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_response_model.dart';
import 'package:ysr_project/features/leaderborad/repo.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

final topLevelsProvider =
    FutureProvider.autoDispose<LeaderboardResponse>((ref) async {
  final dio = ref.read(dioProvider);

  return LeaderBoardRepo(dio: dio).getTopLevels(value: '', level: '');
});

final repoProvider = Provider<LeaderBoardRepo>((ref) {
  final dio = ref.read(dioProvider);
  return LeaderBoardRepo(dio: dio);
});

final leaderBoardProvider = AutoDisposeAsyncNotifierProvider<
    LeaderBoardNotifier, List<LeaderboardEntry>>(LeaderBoardNotifier.new);
