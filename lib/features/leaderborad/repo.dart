import 'package:dio/dio.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_response_model.dart';

class LeaderBoardRepo {
  final Dio dio;

  LeaderBoardRepo({required this.dio});

  Future<LeaderboardResponse> getTopLevels({
    required String level,
    required String value,
  }) async {
    try {
      final response =
          await dio.get('/leaderboard?level=$level&value=$value&top_only=true');
      if (response.statusCode == 200) {
        return LeaderboardResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load leaderboard data');
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard data: $e');
    }
  }

  Future<LeaderboardResponse> getLevels({
    required String level,
    required String value,
    int page = 1,
  }) async {
    try {
      final response = await dio.get(
          '/leaderboard?level=$level&value=$value&top_only=false&page=$page');
      if (response.statusCode == 200) {
        return LeaderboardResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load leaderboard data');
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard data: $e');
    }
  }

  Future<LeaderboardEntry> getLoggedUserRank({
    required String level,
    required String value,
    required int userId,
  }) async {
    try {
      final response = await dio.get(
          '/leaderboard/logged-user-rank?level=$level&value=$value&user_id=$userId');
      if (response.statusCode == 200) {
        return LeaderboardEntry.fromJson(response.data);
      } else {
        throw Exception('Failed to load logged user rank');
      }
    } catch (e) {
      throw Exception('Error fetching logged user rank: $e');
    }
  }
}

LeaderboardResponse getMockLeaderboardResponse() {
  return LeaderboardResponse(
    page: 1,
    pageSize: 10,
    totalUsers: 50,
    totalPages: 5,
    hasNext: true,
    leaderboard: List.generate(20, (index) {
      return LeaderboardEntry(
        rank: index + 1,
        userId: 1000 + index,
        name: "User ${index + 1}",
        state: "State ${index % 5 + 1}",
        parliament: "Parliament ${index % 3 + 1}",
        constituency: "Constituency ${index % 4 + 1}",
        gender: index % 2 == 0 ? "Male" : "Female",
        mobile: "987654321$index",
        email: "user${index + 1}@example.com",
        role: index % 2 == 0 ? "Member" : "Admin",
        totalPoints: 1000 - (index * 10),
        userLevel: index < 3
            ? "Gold"
            : index < 7
                ? "Silver"
                : "Bronze",
      );
    }),
  );
}
