import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_providers.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_response_model.dart';

enum Types {
  state("state"),
  parliament("parliament"),
  assembly("constituency"),
  ;

  final String description;

  const Types(this.description);
}

class LeaderBoardNotifier
    extends AutoDisposeAsyncNotifier<List<LeaderboardEntry>> {
  String stateName = '';
  String parliament = '';
  String assembly = '';
  int page = 1;
  List<LeaderboardEntry> leaderboardData = [];
  Types currentType = Types.state;

  @override
  Future<List<LeaderboardEntry>> build() async {
    final value = await ref.watch(futurePointsProvider.future);
    stateName = value.state!;
    parliament = value.parliament!;
    assembly = value.constituency!;
    leaderboardData = await ref
        .read(repoProvider)
        .getLevels(level: "state", value: "Andhra Pradesh", page: 1)
        .then((response) {
      return response.leaderboard;
    });

    return leaderboardData;
  }

  Future<void> updateType(Types type) async {
    page = 1;
    String valueName = "";
    String value = "";

    switch (type) {
      case Types.state:
        valueName = "state";
        value = stateName;
        currentType = Types.state;
        break;
      case Types.parliament:
        valueName = "parliament";
        value = parliament;
        currentType = Types.parliament;
        break;
      case Types.assembly:
        valueName = "constituency";
        value = assembly;
        currentType = Types.assembly;
        break;
    }

    leaderboardData = await ref
        .read(repoProvider)
        .getLevels(level: valueName, value: value, page: 1)
        .then((response) {
      return response.leaderboard;
    });

    state = AsyncValue.data(leaderboardData);
  }

  Future<void> loadMore() async {
    String valueName = "";
    String value = "";

    switch (currentType) {
      case Types.state:
        valueName = "state";
        value = stateName;
        break;
      case Types.parliament:
        valueName = "parliament";
        value = parliament;
        break;
      case Types.assembly:
        valueName = "constituency";
        value = assembly;
        break;
    }

    page++;
    final newEntries = await ref
        .read(repoProvider)
        .getLevels(level: valueName, value: value, page: page)
        .then((response) {
      return response.leaderboard;
    });

    leaderboardData.addAll(newEntries);
    state = AsyncValue.data(leaderboardData);
  }
}
