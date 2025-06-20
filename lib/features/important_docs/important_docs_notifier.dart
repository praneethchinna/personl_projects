import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

import 'important_docs_repo.dart';
import 'important_docs_response_model.dart';

class ImportantDocsPaginationState {
  final List<ImportantDocFile> documents;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasNext;

  ImportantDocsPaginationState({
    this.documents = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasNext = false,
  });

  ImportantDocsPaginationState copyWith({
    List<ImportantDocFile>? documents,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasNext,
  }) {
    return ImportantDocsPaginationState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}

class ImportantDocsAsyncNotifier
    extends AutoDisposeAsyncNotifier<ImportantDocsPaginationState> {
  late final ImportantDocsRepo repo;
  String? _lastPdfType;
  String? _userId;

  @override
  Future<ImportantDocsPaginationState> build() async {
    repo = ImportantDocsRepo(dio: ref.read(dioProvider));
    return await fetchDocs();
  }

  Future<ImportantDocsPaginationState> fetchDocs(
      {String? pdfType, int page = 1}) async {
    try {
      state = const AsyncLoading();
      final ImportantDocsResponse response =
          await repo.getImportantDocs(pdfType: pdfType, page: page,userId: ref.read(userProvider).userId);
      final newState = ImportantDocsPaginationState(
        documents: response.files,
        isLoading: false,
        error: null,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        hasNext: response.hasNext,
      );
      state = AsyncData(newState);
      return newState;
    } catch (e) {
      final errorState = ImportantDocsPaginationState(
        documents: [],
        isLoading: false,
        error: e.toString(),
      );
      state = AsyncError(e, StackTrace.current);
      return errorState;
    }
  }

  Future<void> fetchNextPage(String? type) async {
    if (type != null) {
      fetchNextPageSaved();
      return;
    }
    final current = state.valueOrNull;
    if (current == null || !current.hasNext) return;
    final nextPage = current.currentPage + 1;
    try {
      state = const AsyncLoading();
      final ImportantDocsResponse response =
          await repo.getImportantDocs(pdfType: _lastPdfType, page: nextPage,userId: ref.read(userProvider).userId);
      state = AsyncData(
        current.copyWith(
          documents: [...current.documents, ...response.files],
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          hasNext: response.hasNext,
        ),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> fetchDocsByType(String? pdfType) async {
    _lastPdfType = pdfType;
    await fetchDocs(pdfType: pdfType);
  }

  Future<void> fetchSavedDocs(String userId) async {
    _userId = userId;
    try {
      state = const AsyncLoading();
      final ImportantDocsResponse response = await repo.getSavedDocsByUser(
        userId: _userId!,
      );
      final newState = ImportantDocsPaginationState(
        documents: response.files,
        isLoading: false,
        error: null,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        hasNext: response.hasNext,
      );
      state = AsyncData(newState);
    } catch (e) {
      final errorState = ImportantDocsPaginationState(
        documents: [],
        isLoading: false,
        error: e.toString(),
      );
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> fetchNextPageSaved() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasNext) return;
    final nextPage = current.currentPage + 1;
    try {
      state = const AsyncLoading();
      final ImportantDocsResponse response =
          await repo.getSavedDocsByUser(userId: _userId!, page: nextPage);
      state = AsyncData(
        current.copyWith(
          documents: [...current.documents, ...response.files],
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          hasNext: response.hasNext,
        ),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final importantDocsAsyncNotifierProvider = AsyncNotifierProvider.autoDispose<
    ImportantDocsAsyncNotifier, ImportantDocsPaginationState>(
  ImportantDocsAsyncNotifier.new,
);
