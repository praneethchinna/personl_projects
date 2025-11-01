import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/features/notifications/data/repository/notifications_repository.dart';
import 'package:ysr_project/features/notifications/domain/models/notification_model.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return NotificationsRepository(dio: dio, ref: ref);
});

final notificationsNotifierProvider = StateNotifierProvider.autoDispose<
    NotificationsNotifier, AsyncValue<NotificationResponse>>((ref) {
  final repository = ref.read(notificationsRepositoryProvider);
  final userId = ref.read(userProvider).userId ?? 0;
  return NotificationsNotifier(repository, userId);
});

class NotificationsNotifier
    extends StateNotifier<AsyncValue<NotificationResponse>> {
  final NotificationsRepository _repository;
  final int _userId;
  int _page = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoading = false;

  NotificationsNotifier(this._repository, this._userId)
      : super(const AsyncValue.loading()) {
    loadInitialNotifications();
  }

  Future<void> loadInitialNotifications() async {
    try {
      state = const AsyncValue.loading();
      final response = await _repository.getNotifications(_userId,
          page: 1, pageSize: _pageSize);
      _hasMore = response.hasNext;
      state = AsyncValue.data(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loadMoreNotifications() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    final currentState = state.valueOrNull;

    if (currentState == null) return;

    try {
      final nextPage = _page + 1;
      final response = await _repository.getNotifications(_userId,
          page: nextPage, pageSize: _pageSize);

      _hasMore = response.hasNext;
      if (_hasMore) {
        _page = nextPage;
      }

      state = AsyncValue.data(NotificationResponse(
        page: response.page,
        pageSize: response.pageSize,
        totalNotifications: response.totalNotifications,
        totalPages: response.totalPages,
        hasNext: response.hasNext,
        notifications: [
          ...currentState.notifications,
          ...response.notifications
        ],
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    await loadInitialNotifications();
  }
}

final notificationReadProvider = StateProvider<Set<int>>((ref) => <int>{});
