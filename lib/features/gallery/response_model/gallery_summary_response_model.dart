class GallerySummaryResponseModel {
  int page;
  int pageSize;
  int totalEvents;
  int totalPages;
  bool hasNext;
  List<EventSummary> events;

  GallerySummaryResponseModel({
    required this.page,
    required this.pageSize,
    required this.totalEvents,
    required this.totalPages,
    required this.hasNext,
    required this.events,
  });

  factory GallerySummaryResponseModel.fromJson(Map<String, dynamic> json) {
    return GallerySummaryResponseModel(
      page: json['page'],
      pageSize: json['page_size'],
      totalEvents: json['total_events'],
      totalPages: json['total_pages'],
      hasNext: json['has_next'],
      events: List<EventSummary>.from(
        json['events'].map((x) => EventSummary.fromJson(x)),
      ),
    );
  }
}

class EventSummary {
  String name;
  DateTime date;
  int imageCount;
  String? sampleImage;

  EventSummary({
    required this.name,
    required this.date,
    required this.imageCount,
    this.sampleImage,
  });

  factory EventSummary.fromJson(Map<String, dynamic> json) {
    return EventSummary(
      name: json['name'],
      date: DateTime.parse(json['date']),
      imageCount: json['image_count'],
      sampleImage: json['sample_image'],
    );
  }
}
