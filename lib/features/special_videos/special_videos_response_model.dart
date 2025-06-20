class SpecialVideo {
  final int id;
  final String title;
  final String videoUrl;
  final String description;
  final int createdBy;
  final String createdTime;
  final int updatedBy;
  final String updatedTime;
  final String? thumbnailUrl;

  SpecialVideo({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.description,
    required this.createdBy,
    required this.createdTime,
    required this.updatedBy,
    required this.updatedTime,
    this.thumbnailUrl,
  });

  factory SpecialVideo.fromJson(Map<String, dynamic> json) {
    return SpecialVideo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      videoUrl: json['video_url'] ?? '',
      description: json['description'] ?? '',
      createdBy: json['created_by'] ?? 0,
      createdTime: json['created_time'] ?? '',
      updatedBy: json['updated_by'] ?? 0,
      updatedTime: json['updated_time'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}

class SpecialVideosResponseModel {
  final int page;
  final int pageSize;
  final int totalVideos;
  final int totalPages;
  final bool hasNext;
  final List<SpecialVideo> videos;

  SpecialVideosResponseModel({
    required this.page,
    required this.pageSize,
    required this.totalVideos,
    required this.totalPages,
    required this.hasNext,
    required this.videos,
  });

  factory SpecialVideosResponseModel.fromJson(Map<String, dynamic> json) {
    return SpecialVideosResponseModel(
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 0,
      totalVideos: json['total_videos'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
      hasNext: json['has_next'] ?? false,
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => SpecialVideo.fromJson(e))
              .toList() ??
          [],
    );
  }
}
