class UserPointsResponseModel {
  int? userId;
  String? userName;
  int? totalPoints;
  String? userLevel;

  UserPointsResponseModel({
    this.userId,
    this.userName,
    this.totalPoints,
    this.userLevel,
  });

  factory UserPointsResponseModel.fromJson(Map<String, dynamic> json) =>
      UserPointsResponseModel(
        userId: json["user_id"],
        userName: json["user_name"],
        totalPoints: json["total_points"],
        userLevel: json["user_level"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "total_points": totalPoints,
        "user_level": userLevel,
      };
}
