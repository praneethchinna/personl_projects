import 'package:ysr_project/features/leaderborad/leaderboard_notifier.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_response_model.dart';

class LeaderBoardViewModel {
  List<LeaderboardEntry> stateLeaderboard;
  List<LeaderboardEntry> parliamentLeaderboard;
  List<LeaderboardEntry> assemblyLeaderboard;

  LeaderBoardViewModel({
    required this.stateLeaderboard,
    required this.parliamentLeaderboard,
    required this.assemblyLeaderboard,
  });
}

class LeaderBoardState {
  List<LeaderboardEntry> topLevels;
  LeaderBoards leaderBoards;
  Types type;
  List<String> names;
  String selectedName;
  LeaderboardEntry loggedUserRank;

  LeaderBoardState({
    required this.topLevels,
    required this.leaderBoards,
    required this.type,
    required this.names,
    required this.selectedName,
    required this.loggedUserRank,
  });

  LeaderBoardState copyWith({
    List<LeaderboardEntry>? topLevels,
    LeaderBoards? leaderBoards,
    Types? type,
    List<String>? names,
    String? selectedName,
    LeaderboardEntry? loggedUserRank,
  }) {
    return LeaderBoardState(
      loggedUserRank: loggedUserRank ?? this.loggedUserRank,
      topLevels: topLevels ?? this.topLevels,
      leaderBoards: leaderBoards ?? this.leaderBoards,
      type: type ?? this.type,
      names: names ?? this.names,
      selectedName: selectedName ?? this.selectedName,
    );
  }
}

class LeaderBoards {
  List<LeaderboardEntry> leaderBoards;
  bool hasNext;

  LeaderBoards({
    required this.leaderBoards,
    required this.hasNext,
  });

  LeaderBoards copyWith({
    List<LeaderboardEntry>? leaderBoards,
    bool? hasNext,
  }) {
    return LeaderBoards(
      leaderBoards: leaderBoards ?? this.leaderBoards,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
