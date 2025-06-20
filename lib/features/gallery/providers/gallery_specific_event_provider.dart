import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/gallery/repo/gallary_repo.dart';
import 'package:ysr_project/features/gallery/response_model/events_response_model.dart';
import 'package:ysr_project/features/gallery/response_model/galary_response_model.dart';
import 'package:ysr_project/features/gallery/view_model/gallery_view_model.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

final galleryImageProvider = AsyncNotifierProvider.family
    .autoDispose<GalleryImageNotifier, GalleryViewModel, String>(
  GalleryImageNotifier.new,
);

/// Notifier responsible for fetching gallery images based on an event/image ID.
class GalleryImageNotifier
    extends AutoDisposeFamilyAsyncNotifier<GalleryViewModel, String> {
  late final String eventId;
  List<Images> galleryResponseModel = [];
  late GalleryRepo galleryRepo;
  int _page =
      1; // Initialize page variable, though not used in the current method

  /// The build method is called once when the provider is first accessed.
  /// It takes the `arg` (a String) and uses it to fetch the gallery data.
  @override
  Future<GalleryViewModel> build(String arg) async {
    eventId = arg;

    try {
      final dio = ref.read(dioProvider);

      galleryRepo = GalleryRepo(dio, ref);

      final galleryResponse = await galleryRepo.fetchImages(eventId);
      galleryResponseModel = galleryResponse.images;
      return GalleryViewModel(
        eventsResponseModel: EventsResponseModel(events: []),
        galleryResponseModel:
            GalleryResponseModel(images: galleryResponseModel),
      );
    } catch (error, stackTrace) {
      print(
          'Error fetching gallery images for ID $eventId: $error\n$stackTrace');
      throw Exception('Failed to load gallery images for ID $eventId: $error');
    }
  }

  Future<void> loadMoreImages() async {
    _page++;
    try {
      final galleryResponse =
          await galleryRepo.fetchImages(eventId, page: _page);
      // Increment the page for the next load
      if (galleryResponse.images.isNotEmpty) {
        galleryResponseModel.addAll(galleryResponse.images);
        state = AsyncValue.data(
          state.value!.copyWith(
            galleryResponseModel: GalleryResponseModel(
              images: galleryResponseModel,
            ),
          ),
        );
      } else {
        return;
      }
    } on Exception catch (error, stackTrace) {
      print('Error loading more images for ID $eventId: $error\n$stackTrace');
      state = AsyncValue.error(
        'Failed to load more images for ID $eventId: $error',
        stackTrace,
      );
    }
  }
}
