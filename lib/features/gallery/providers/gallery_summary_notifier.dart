import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/features/gallery/response_model/gallery_summary_response_model.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

class GallerySummaryState {
  final List<EventSummary> events;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasNext;

  GallerySummaryState({
    this.events = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 0,
    this.hasNext = false,
  });

  GallerySummaryState copyWith({
    List<EventSummary>? events,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasNext,
  }) {
    return GallerySummaryState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}

class GallerySummaryNotifier extends AutoDisposeAsyncNotifier<GallerySummaryState> {
  late final Dio _dio;

  @override
  Future<GallerySummaryState> build() async {
    _dio = ref.read(dioProvider);
    return await _fetchGallerySummary(page: 1, existingEvents: []);
  }

  Future<GallerySummaryState> _fetchGallerySummary({
    required int page,
    required List<EventSummary> existingEvents,
  }) async {
    try {
      final response = await _dio.get('/events/summary?page=$page&pageSize=10');
      if (response.statusCode == 200) {
        final model = GallerySummaryResponseModel.fromJson(response.data);

        return GallerySummaryState(
          events: [...existingEvents, ...model.events],
          currentPage: model.page,
          totalPages: model.totalPages,
          hasNext: model.hasNext,
        );
      } else {
        return GallerySummaryState(
          events: existingEvents,
          error: 'Failed to fetch data (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      return GallerySummaryState(
        events: existingEvents,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchNextGallerySummary() async {
    final currentState = state.valueOrNull;

    if (currentState == null || currentState.isLoading || !currentState.hasNext)
      return;

    // Optimistically mark loading
    state = AsyncData(currentState.copyWith(isLoading: true));

    final nextPage = currentState.currentPage + 1;
    final newState = await _fetchGallerySummary(
      page: nextPage,
      existingEvents: currentState.events,
    );

    state = AsyncData(newState);
  }
}

final gallerySummaryProvider =
    AutoDisposeAsyncNotifierProvider<GallerySummaryNotifier, GallerySummaryState>(
  GallerySummaryNotifier.new,
);
