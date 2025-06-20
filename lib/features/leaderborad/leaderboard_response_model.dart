class LeaderboardResponse {
  LeaderboardResponse({
    required this.page,
    required this.pageSize,
    required this.totalUsers,
    required this.totalPages,
    required this.hasNext,
    required this.leaderboard,
  });

  int page;
  int pageSize;
  int totalUsers;
  int totalPages;
  bool hasNext;
  List<LeaderboardEntry> leaderboard;

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      LeaderboardResponse(
        page: json["page"],
        pageSize: json["page_size"],
        totalUsers: json["total_users"],
        totalPages: json["total_pages"],
        hasNext: json["has_next"],
        leaderboard: List<LeaderboardEntry>.from(
            json["leaderboard"].map((x) => LeaderboardEntry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "page_size": pageSize,
        "total_users": totalUsers,
        "total_pages": totalPages,
        "has_next": hasNext,
        "leaderboard": List<dynamic>.from(leaderboard.map((x) => x.toJson())),
      };
}

// Class for individual leaderboard entries
class LeaderboardEntry {
  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.name,
    required this.state,
    required this.parliament,
    required this.constituency,
    required this.gender,
    required this.mobile,
    required this.email,
    required this.role,
    required this.totalPoints,
    required this.userLevel,
  });

  int rank;
  int userId;
  String name;
  String state;
  String parliament;
  String constituency;
  String gender;
  String mobile;
  String email;
  String role;
  int totalPoints;
  String userLevel;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        rank: json["rank"],
        userId: json["user_id"],
        name: json["name"],
        state: json["state"],
        parliament: json["parliament"],
        constituency: json["constituency"],
        gender: json["gender"],
        mobile: json["mobile"],
        email: json["email"],
        role: json["role"],
        totalPoints: json["total_points"],
        userLevel: json["user_level"],
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "user_id": userId,
        "name": name,
        "state": state,
        "parliament": parliament,
        "constituency": constituency,
        "gender": gender,
        "mobile": mobile,
        "email": email,
        "role": role,
        "total_points": totalPoints,
        "user_level": userLevel,
      };
}
