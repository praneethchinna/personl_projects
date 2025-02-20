import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/profile/response_model/profile_response_model.dart';

class ProfileRepo {
  final Dio dio;
  final Ref ref;

  ProfileRepo({required this.dio, required this.ref});

  Future<ProfileResponseModel> getProfileData(String phoneNumber) async {
    try {
      final response = await dio
          .get('/user/details', queryParameters: {'mobile': phoneNumber});
      if (response.statusCode == 200) {
        return ProfileResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Error fetching profile data: $e');
    }
  }
}
