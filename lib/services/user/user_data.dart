import 'package:hooks_riverpod/hooks_riverpod.dart';

class User {
  final String message;
  final int userId;
  final String name;
  final String role;
  final String mobile;
  final String? parliament;
  final String constituency;

  User({
    required this.message,
    required this.userId,
    required this.name,
    required this.role,
    required this.mobile,
    this.parliament,
    required this.constituency,
  });

  // Convert JSON to Dart Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      message: json['message'],
      userId: json['user_id'],
      name: json['name'],
      role: json['role'],
      mobile: json['mobile'],
      parliament: json['parliament'], // Can be null
      constituency: json['constituency'],
    );
  }

  // Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user_id': userId,
      'name': name,
      'role': role,
      'mobile': mobile,
      'parliament': parliament,
      'constituency': constituency,
    };
  }
}

final userProvider = StateProvider<User>((ref) {
  return User(
    message: '',
    userId: 0,
    name: '',
    role: '',
    mobile: '',
    parliament: '',
    constituency: '',
  );
});
