class LoginResponseModel {
  String message;
  int userId;
  String name;
  String role;
  String mobile;
  String? parliament;
  String constituency;

  LoginResponseModel({
    required this.message,
    required this.userId,
    required this.name,
    required this.role,
    required this.mobile,
    this.parliament,
    required this.constituency,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: json["message"],
        userId: json["user_id"],
        name: json["name"],
        role: json["role"],
        mobile: json["mobile"],
        parliament: json["parliament"],
        constituency: json["constituency"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user_id": userId,
        "name": name,
        "role": role,
        "mobile": mobile,
        "parliament": parliament,
        "constituency": constituency,
      };
}
