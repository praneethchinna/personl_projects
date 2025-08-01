import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/gallery/response_model/events_response_model.dart';
import 'package:ysr_project/features/gallery/response_model/galary_response_model.dart';
import 'package:ysr_project/features/gallery/response_model/gallery_summary_response_model.dart';

class GalleryRepo {
  final Dio _dio;
  final Ref _ref;

  GalleryRepo(this._dio, this._ref);

  Future<EventsResponseModel> fetchEvents() async {
    try {
      final response = await _dio.get('/events');
      if (response.statusCode == 200) {
        return EventsResponseModel.fromJson(response.data);
      } else {
        return throw Exception("Failed to fetch events");
      }
    } catch (e) {
      return throw Exception("Failed to fetch events");
    }
  }

  Future<GalleryResponseModel> fetchImages(
    String eventId, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get('/events/$eventId/images?page=$page');
      if (response.statusCode == 200) {
        return GalleryResponseModel.fromJson(response.data);
      } else {
        return throw Exception("Failed to fetch images");
      }
    } catch (e) {
      return throw Exception("Failed to fetch images");
    }
  }

  Future<GallerySummaryResponseModel> fetchGallerySummary(
      {int page = 1}) async {
    try {
      final response = await _dio.get('/events/summary?page=$page');
      if (response.statusCode == 200) {
        return GallerySummaryResponseModel.fromJson(response.data);
      } else {
        return throw Exception("Failed to fetch gallery summary");
      }
    } catch (e) {
      return throw Exception("Failed to fetch gallery summary");
    }
  }
}
