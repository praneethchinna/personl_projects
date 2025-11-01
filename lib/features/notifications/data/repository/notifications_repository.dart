import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/models/notification_model.dart';

class NotificationsRepository {
  final Dio dio;
  final Ref ref;

  NotificationsRepository({required this.dio, required this.ref});

  Future<NotificationResponse> getNotifications(int userId,
      {int page = 1, int pageSize = 10}) async {
    try {
      final response = await dio.get(
        '/notifications/userfeed',
        queryParameters: {
          'user_id': userId,
          'page': page,
          'page_size': pageSize,
        },
      );

      if (response.statusCode == 200) {
        return NotificationResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load notifications');
      }
    } on DioException catch (e) {
      // For demo purposes, return sample data if API fails
      if (e.response?.statusCode == 404) {
        return _getSampleNotifications();
      }
      throw Exception('Error fetching notifications: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Fallback sample data
  NotificationResponse _getSampleNotifications() {
    return NotificationResponse(
      page: 1,
      pageSize: 10,
      totalNotifications: 15,
      totalPages: 2,
      hasNext: true,
      notifications: [
        NotificationModel(
          id: 1,
          source: 'Sakshi',
          text:
              'Sakshi posted a new video: Ambati Rambabu Reveal Facts About Chandrababu Super Six',
          postType: 'influencer_video',
          refId: '1634',
          createdAt: '2025-06-15T04:45:06',
          viewed: false,
        ),
        NotificationModel(
          id: 2,
          source: 'Sakshi',
          text:
              'Sakshi posted a new video: Ambati Rambabu Counter To Nara Lokesh Warning',
          postType: 'influencer_video',
          refId: '1633',
          createdAt: '2025-06-15T03:00:06',
          viewed: false,
        ),
      ],
    );
  }
}
