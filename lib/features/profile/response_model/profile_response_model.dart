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
  final String country;
  final String referralCode;
  final String state;

  User({
    this.userId = 0,
    this.name = '',
    this.constituency = '',
    this.email = '',
    this.role = '',
    this.parliament = '',
    this.mobile = '',
    this.gender = '',
    this.country = "",
    this.referralCode = "",
    this.state = "",
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['user_id'] ?? 0,
        name: json['name'] ?? '',
        constituency: json['constituency'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? '',
        parliament: json['parliament'] ?? '',
        mobile: json['mobile'] ?? '',
        gender: json['gender'] ?? '',
        country: json['country'] ?? '',
        referralCode: json['referral_code'] ?? '',
        state: json['state'] ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'constituency': constituency,
      'email': email,
      'role': role,
      'parliament': parliament,
      'mobile': mobile,
      'gender': gender,
      'country': country,
      'referral_code': referralCode,
    };
  }
}
