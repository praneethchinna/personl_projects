import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/gallery/repo/gallary_repo.dart';
import 'package:ysr_project/features/gallery/response_model/events_response_model.dart';
import 'package:ysr_project/features/gallery/response_model/galary_response_model.dart';
import 'package:ysr_project/features/gallery/view_model/gallery_view_model.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

final galleryNotifierProvider =
    StateNotifierProvider.autoDispose<GalleryNotifier, GalleryViewModel>((ref) {
  final dio = ref.read(dioProvider);
  final galleryRepo = GalleryRepo(dio, ref);

  return GalleryNotifier(galleryRepo);
});

class GalleryNotifier extends StateNotifier<GalleryViewModel> {
  final GalleryRepo galleryRepo;

  GalleryNotifier(this.galleryRepo)
      : super(GalleryViewModel(
            eventsResponseModel: EventsResponseModel(events: []),
            galleryResponseModel: GalleryResponseModel(images: []))) {
    build();
  }

  FutureOr<void> build() async {
    try {
      final eventsList = await galleryRepo.fetchEvents();
      final eventName = eventsList.events.first.name;
      state = state.copyWith(eventsResponseModel: eventsList);
      updateEvent(eventName);
    } catch (e) {
      state = state.copyWith(isLoading: false, isError: e.toString());
      rethrow;
    }
  }

  void updateEvent(String name) {
    state = state.copyWith(eventName: name);
    state = state.copyWith(isLoading: true);
    fetchImages(name);
  }

  Future<void> fetchImages(String eventId) async {
    try {
      final response = await galleryRepo.fetchImages(eventId);
      state = state.copyWith(galleryResponseModel: response, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, isError: e.toString());
      rethrow;
    }
  }
}
