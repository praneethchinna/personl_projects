import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/response_model/grievance_categories_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/grievance_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/grievance_status.dart';
import 'package:ysr_project/features/home_screen/response_model/home_feeds_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/influencer_video_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/notification_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/pdf_files_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/special_points.dart';
import 'package:ysr_project/features/home_screen/response_model/special_videos.dart';
import 'package:ysr_project/features/home_screen/response_model/user_points_response_model.dart';
import 'package:ysr_project/services/user/user_data.dart';

class HomeFeedsRepoImpl {
  final Dio dio;
  final Ref ref;

  HomeFeedsRepoImpl({required this.dio, required this.ref});

  Future<List<HomeFeedsResponseModel>> getHomeFeeds() async {
    try {
      final userId = ref.read(userProvider).userId;
      final response = await dio.get('/uploads/homefeeduser?user_id=$userId');
      if (response.statusCode == 200) {
        return homeFeedsResponseModelFromJson(response.data);
      } else {
        return throw Exception("Failed to fetch Home Feeds");
      }
    } catch (e) {
      return throw Exception("Failed to fetch Home Feeds");
    }
  }

  Future<List<Grievance>> getGrievances() async {
    try {
      final response = await dio.get('/grievances');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((value) => Grievance.fromJson(value))
            .toList();
      } else {
        return throw Exception("Failed to fetch Grievances");
      }
    } catch (e) {
      return throw Exception("Failed to fetch Grievances");
    }
  }

  Future<UserPointsResponseModel> getUserPoints() async {
    try {
      final userId = ref.read(userProvider).userId;
      final response = await dio.get('/user/points/$userId');
      if (response.statusCode == 200) {
        return UserPointsResponseModel.fromJson(response.data);
      } else {
        return throw Exception("Failed to fetch User Points");
      }
    } catch (e) {
      return throw Exception("Failed to fetch User Points");
    }
  }

  Future<bool> postAction({
    required String action,
    required String batchId,
    required String userName,
    required String commentText,
    required String shareType,
  }) async {
    try {
      final userId = ref.read(userProvider).userId;
      final response = await dio.post('/post/action', data: {
        'action': action,
        'batch_id': batchId,
        'user_id': userId,
        'user_name': userName,
        'comment_text': commentText,
        'share_type': shareType,
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        throw "You have reached the maximum share limit for this post(10 times)";
      }
    } catch (e) {
      throw "You have reached the maximum share limit for this post(10 times)";
    }
  }

  Future<NotificationResponseModel> getLatestVideos() async {
    try {
      final response = await dio.get('/check_videos');
      if (response.statusCode == 200) {
        return NotificationResponseModel.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch Latest Videos");
      }
    } catch (e) {
      throw Exception("Failed to fetch Latest Videos");
    }
  }

  Future<List<SpecialPoints>> getUserPointsForBatchId(String batchId) async {
    try {
      final response = await dio.get('/special_points/$batchId');
      if (response.statusCode == 200) {
        final listOfPoints = response.data as List;
        return listOfPoints
            .map((element) => SpecialPoints.fromJson(element))
            .toList();
      } else {
        throw Exception("Failed to fetch User Points for Batch Id");
      }
    } catch (e) {
      throw Exception("Failed to fetch User Points for Batch Id");
    }
  }

  Future<String> getUrl() async {
    try {
      final response = await dio.get('/live-videos');
      if (response.statusCode == 200) {
        return response.data['video_url'];
      }
      throw Exception("Failed to fetch url");
    } catch (e) {
      throw Exception("Failed to fetch url");
    }
  }

  Future<List<SpecialVideos>> getSpecialVideos() async {
    try {
      final response = await dio.get('/special-videos');
      if (response.statusCode == 200) {
        final listOfVideos = response.data as List;
        return listOfVideos
            .map((element) => SpecialVideos.fromJson(element))
            .toList();
      } else {
        throw Exception("Failed to fetch Special Videos");
      }
    } catch (e) {
      throw Exception("Failed to fetch Special Videos");
    }
  }

  Future<List<InfluencerVideoResponseModel>> getInfluencerVideos() async {
    try {
      final response = await dio.get('/check_videos');
      if (response.statusCode == 200) {
        final listOfVideos = response.data["latest_videos"] as List;
        return listOfVideos
            .map((element) => InfluencerVideoResponseModel.fromJson(element))
            .toList();
      } else {
        throw Exception("Failed to fetch Influencer Videos");
      }
    } catch (e) {
      throw Exception("Failed to fetch Influencer Videos");
    }
  }

  Future<List<PdfFilesResponseModel>> getPdfFiles() async {
    try {
      final response = await dio.get('/list-pdfs/');
      if (response.statusCode == 200) {
        final listOfVideos = response.data["files"] as List;
        return listOfVideos
            .map((element) => PdfFilesResponseModel.fromJson(element))
            .toList();
      } else {
        throw Exception("Failed to fetch Pdf Files");
      }
    } catch (e) {
      throw Exception("Failed to fetch Pdf Files");
    }
  }

  Future<bool> updateProfileDetails({
    required String name,
    required String email,
    required String gender,
    required String country,
    required String state,
    required String parliament,
    required String constituency,
  }) async {
    try {
      final queryParameters = {
        'name': name,
        'email': email,
        'gender': gender,
        'country': country,
        'state': state,
        'parliament': parliament,
        'constituency': constituency,
      };
      final userData = ref.read(userProvider);
      final response = await dio.put('/user/update-profile',
          queryParameters: {"mobile": userData.mobile}, data: queryParameters);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to update profile details");
      }
    } catch (e) {
      throw Exception("Failed to update profile details");
    }
  }

  Future<bool> submitGrievance({
    required String name,
    required String gender,
    required String email,
    required String parliament,
    required String assembly,
    required String categoryName,
    required String grievanceDescription,
    required String idProofType,
    required XFile? selfie, // XFile or null
    required File? idProof, // File or null
  }) async {
    try {
      final mobile = ref.read(userProvider).mobile;
      final userId = ref.read(userProvider).userId;
      // Construct FormData
      final formData = FormData.fromMap({
        "name": name,
        "gender": gender,
        "mobile": mobile,
        "email": email,
        "parliament": parliament,
        "assembly": assembly,
        "category_name": categoryName,
        "grievance_description": grievanceDescription,
        "id_proof_type": idProofType,

        "user_id": userId,
        // Convert selfie from XFile to MultipartFile if not null
        if (selfie != null)
          "selfie": await MultipartFile.fromFile(
            selfie.path,
            filename: selfie.name,
          ),
        // Convert idProof from File to MultipartFile if not null
        if (idProof != null)
          "id_proof": await MultipartFile.fromFile(
            idProof.path,
            filename: idProof.path.split('/').last,
          ),
      });

      final response =
          await dio.post('/submit-grievance-mobile', data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            "Failed to submit grievance: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Failed to submit grievance: $e");
    }
  }

  Future<List<GrievanceCategoryResponseModel>> grievanceCategories() async {
    try {
      final response = await dio.get('/grievance-categories');

      if (response.statusCode == 200) {
        if (response.data == null || (response.data as List).isEmpty) {
          return [];
        }
        return (response.data as List)
            .map((e) => GrievanceCategoryResponseModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to fetch grievance categories");
      }
    } catch (e) {
      throw Exception("Failed to fetch grievance categories: $e");
    }
  }

  Future<List<GrievanceStatus>> getGrievanceHistory(int id) async {
    try {
      final response = await dio.get('/grievances/$id/history');

      if (response.statusCode == 200) {
        if (response.data == null || (response.data as List).isEmpty) {
          return [];
        }
        return (response.data as List)
            .map((e) => GrievanceStatus.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to fetch grievance history");
      }
    } catch (e) {
      throw Exception("Failed to fetch grievance history: $e");
    }
  }
}
