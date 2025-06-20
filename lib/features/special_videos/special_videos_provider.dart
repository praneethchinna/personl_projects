import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

import 'special_videos_repo.dart';
import 'special_videos_response_model.dart';

final specialVideosRepoProvider = Provider<SpecialVideosRepo>((ref) {
  final dio = ref.read(dioProvider);
  return SpecialVideosRepo(dio: dio);
});

class SpecialVideosPaginationState {
  final List<SpecialVideo> videos;
  final int currentPage;
  final int totalPages;
  final bool hasNext;
  final bool isLoading;
  final String? error;

  SpecialVideosPaginationState({
    this.videos = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasNext = false,
    this.isLoading = false,
    this.error,
  });

  SpecialVideosPaginationState copyWith({
    List<SpecialVideo>? videos,
    int? currentPage,
    int? totalPages,
    bool? hasNext,
    bool? isLoading,
    String? error,
  }) {
    return SpecialVideosPaginationState(
      videos: videos ?? this.videos,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SpecialVideosPaginationNotifier
    extends StateNotifier<SpecialVideosPaginationState> {
  final SpecialVideosRepo repo;
  SpecialVideosPaginationNotifier(this.repo)
      : super(SpecialVideosPaginationState()) {
    fetchFirstPage();
  }

  Future<void> fetchFirstPage() async {
    state = state
        .copyWith(isLoading: true, error: null, currentPage: 1, videos: []);
    try {
      final response = await repo.getSpecialVideos(page: 1);
      state = state.copyWith(
        videos: response.videos,
        currentPage: response.page,
        totalPages: response.totalPages,
        hasNext: response.hasNext,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchNextPage() async {
    if (!state.hasNext || state.isLoading) return;
    final nextPage = state.currentPage + 1;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await repo.getSpecialVideos(page: nextPage);
      state = state.copyWith(
        videos: [...state.videos, ...response.videos],
        currentPage: response.page,
        totalPages: response.totalPages,
        hasNext: response.hasNext,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final specialVideosPaginationProvider = StateNotifierProvider.autoDispose<
    SpecialVideosPaginationNotifier, SpecialVideosPaginationState>((ref) {
  return SpecialVideosPaginationNotifier(ref.read(specialVideosRepoProvider));
});
