import 'package:ysr_project/features/gallery/response_model/events_response_model.dart';
import 'package:ysr_project/features/gallery/response_model/galary_response_model.dart';

class GalleryViewModel {
  final String eventName;
  final bool isLoading;
  final String isError;
  final EventsResponseModel eventsResponseModel;
  final GalleryResponseModel galleryResponseModel;

  GalleryViewModel({
    this.eventName = "",
    this.isLoading = true,
    this.isError = "",
    required this.eventsResponseModel,
    required this.galleryResponseModel,
  });

  GalleryViewModel copyWith({
    String? eventName,
    bool? isLoading,
    String? isError,
    EventsResponseModel? eventsResponseModel,
    GalleryResponseModel? galleryResponseModel,
  }) {
    return GalleryViewModel(
      eventName: eventName ?? this.eventName,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      eventsResponseModel: eventsResponseModel ?? this.eventsResponseModel,
      galleryResponseModel: galleryResponseModel ?? this.galleryResponseModel,
    );
  }
}
