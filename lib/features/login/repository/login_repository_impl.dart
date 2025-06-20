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
    try {
      final response = await dio.post(
        '/login',
        data: {'mobile': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return await updateUserData(response);
      }
      throw Exception(response.data["detail"]);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data["detail"][0] != null) {
        throw Exception(e.response?.data["detail"]);
      }
      throw Exception("An error occurred. Please try again.");
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUserDetails() async {
    final signupData = ref.read(signupProvider);
    try {
      Map<String, dynamic> body = {
        "name": signupData.fullName,
        "gender": signupData.isMale ? "Male" : "Female",
        "country": signupData.country ?? "",
        "state": signupData.state ?? "",
        "parliament": signupData.parliament?.parliamentId ?? 0,
        "constituency": signupData.assembly?.assemblyId ?? 0,
        "mobile": signupData.mobileNumber,
        "email": signupData.email ?? "",
        "password": signupData.password,
      };

      if (signupData.referralCode != null &&
          signupData.referralCode!.isNotEmpty) {
        body["referral_code"] = signupData.referralCode;
      }

      final response = await dio.post('/signup', data: body);

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

  Future<bool> signInGoogleWithEmail(String email) async {
    try {
      final response = await dio.post("/auth/email", data: {"email": email});

      if (response.statusCode == 200 && response.data['user_id'] != null) {
        if (response.data["blocked"] == true) {
          throw Exception("User is blocked. Please, contact Support Team");
        }
        final value = await updateUserData(response);
        return value;
      }
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> updateUserData(dynamic response) async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
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
    } catch (e) {
      return false;
    }
  }

  Future<bool> newUserOtp(String mobile) async {
    try {
      final response =
          await dio.post("/generate-otp", data: {"mobile": mobile});
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception("Failed to get otp");
    } on DioException catch (e) {
      throw Exception(e.response?.data["detail"] ?? "An error occurred.");
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyNewUserOtp(String mobile, String otp) async {
    try {
      final response = await dio.post("/verify-otp", data: {
        "mobile": mobile,
        "otp": otp,
      });
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception("Failed to get otp");
    } on DioException catch (e) {
      throw Exception(e.response?.data["detail"] ?? "An error occurred.");
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getForgotOtp(String mobile) async {
    try {
      final response =
          await dio.post("/forgot-password-otp", data: {"mobile": mobile});
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception(response.data["detail"]);
    } on DioException catch (e) {
      throw Exception(e.response?.data["detail"] ?? "An error occurred.");
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyForgotOtp(String mobile, String otp) async {
    try {
      final response = await dio.post("/verify-forgot-password-otp", data: {
        "mobile": mobile,
        "otp": otp,
      });
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception("Failed to verify forgot otp");
    } on DioException catch (e) {
      throw Exception(e.response?.data["detail"] ?? "An error occurred.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> resetPassword(String mobile, String newPassword) async {
    try {
      final response = await dio.post("/reset-password", data: {
        "mobile": mobile,
        "new_password": newPassword,
      });
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception("Failed to get otp");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void handleDioError(int? statusCode, [dynamic error]) {
    if (statusCode != null) {
      if (statusCode == 403 &&
          error is DioException &&
          error.response?.data != null) {
        final detailMessage =
            error.response?.data['detail'] ?? "Access Forbidden (403)";
        throw Exception("🚫 $detailMessage");
      }

      switch (statusCode) {
        case 422:
          throw Exception("Validation Error (422)");
        default:
          throw Exception("Request failed with status: $statusCode");
      }
    } else if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception("Connection Timeout");
        case DioExceptionType.sendTimeout:
          throw Exception("Send Timeout");
        case DioExceptionType.receiveTimeout:
          throw Exception("Receive Timeout");
        case DioExceptionType.badResponse:
          throw Exception("Server Error: ${error.response?.statusCode}");
        case DioExceptionType.cancel:
          throw Exception("Request Cancelled");
        case DioExceptionType.connectionError:
          throw Exception("No Internet Connection");
        default:
          throw Exception("Unexpected Error: ${error.message}");
      }
    } else {
      throw Exception("Unknown Error Occurred");
    }
  }
}
