import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/login/providers/login_provider.dart';
import 'package:ysr_project/services/shared_preferences/shared_preferences_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

class LoginRepositoryImpl {
  final Dio dio;
  final Ref ref;

  LoginRepositoryImpl({required this.dio, required this.ref});

  Future<bool> login(String email, String password) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    try {
      final response = await dio
          .post('/login', data: {'mobile': email, 'password': password});

      if (response.statusCode == 200) {
        prefs.setString("userData", jsonEncode(response.data));
        final userRealData = response.data;
        ref.read(userProvider.notifier).update(
              (state) => User(
                message: userRealData['message'],
                userId: userRealData['user_id'],
                name: userRealData['name'],
                role: userRealData['role'],
                mobile: userRealData['mobile'],
                parliament: userRealData['parliament'],
                constituency: userRealData['constituency'],
              ),
            );
        return true;
      } else if (response.statusCode == 422) {
        return throw Exception("Failed to login");
      }
      return throw Exception("Failed to login");
    } catch (e) {
      return throw Exception("Failed to login");
    }
  }

  Future<bool> updateUserDetails() async {
    final signupData = ref.read(signupProvider);
    try {
      final response = await dio.post('/signup', data: {
        "name": signupData.fullName,
        "gender": signupData.isMale ? "Male" : "Female",
        "country": signupData.country ?? "",
        "state": signupData.state ?? "",
        "parliament": signupData.parliament?.parliamentId ?? 0,
        "constituency": signupData.assembly?.assemblyId ?? 0,
        "mobile": signupData.mobileNumber,
        "email": signupData.email ?? "",
        "password": signupData.password
      });

      if (response.statusCode == 200) {
        ref.invalidate(signupProvider);
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      return throw Exception(e.response!.data['detail']);
    } catch (e) {
      return throw Exception("Failed to SignUp");
    }
  }
}
