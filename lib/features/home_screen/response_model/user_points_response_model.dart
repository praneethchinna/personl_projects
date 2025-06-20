class UserPointsResponseModel {
  int? userId;
  String? userName;
  int? totalPoints;
  String? userLevel;
  int? likedCount;
  int? commentedCount;
  int? sharedCount;
  String? parliament;
  String? constituency;
  String? state;

  UserPointsResponseModel({
    required this.userId,
    required this.userName,
    required this.totalPoints,
    required this.userLevel,
    required this.likedCount,
    required this.commentedCount,
    required this.sharedCount,
    this.parliament,
    this.constituency,
    this.state,
  });

  factory UserPointsResponseModel.fromJson(Map<String, dynamic> json) =>
      UserPointsResponseModel(
        userId: json["user_id"],
        userName: json["name"],
        totalPoints: json["total_points"],
        userLevel: json["user_level"],
        likedCount: json["liked_count"],
        commentedCount: json["commented_count"],
        sharedCount: json["shared_count"],
        parliament: json["parliament"],
        constituency: json["constituency"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "total_points": totalPoints,
        "user_level": userLevel,
        "liked_count": likedCount,
        "commented_count": commentedCount,
        "shared_count": sharedCount,
        "parliament": parliament,
        "constituency": constituency,
        "state": state,
      };
}
