class ProfileResponseModel {
  User? user;

  ProfileResponseModel({this.user});

  ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  final int userId;
  final String name;
  final String constituency;
  final String email;
  final String role;
  final String parliament;
  final String mobile;
  final String gender;

  User({
    this.userId = 0,
    this.name = '',
    this.constituency = '',
    this.email = '',
    this.role = '',
    this.parliament = '',
    this.mobile = '',
    this.gender = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['user_id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        constituency: json['constituency'] as String? ?? '',
        email: json['email'] as String? ?? '',
        role: json['role'] as String? ?? '',
        parliament: json['parliament'] as String? ?? '',
        mobile: json['mobile'] as String? ?? '',
        gender: json['gender'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['constituency'] = constituency;
    data['email'] = email;
    data['role'] = role;
    data['parliament'] = parliament;
    data['mobile'] = mobile;
    data['gender'] = gender;
    return data;
  }
}
