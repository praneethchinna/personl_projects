class InfluencerVideo {
  final int videoId;
  final String videoTitle;
  final String videoUrl;
  final DateTime publishedAt;

  InfluencerVideo({
    required this.videoId,
    required this.videoTitle,
    required this.videoUrl,
    required this.publishedAt,
  });

  factory InfluencerVideo.fromJson(Map<String, dynamic> json) {
    return InfluencerVideo(
      videoId: json['video_id'],
      videoTitle: json['video_title'],
      videoUrl: json['video_url'],
      publishedAt: DateTime.parse(json['published_at']),
    );
  }
}

class InfluencerVideoPaginatedResponse {
  final int influencerId;
  final String influencerName;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalVideos;
  final List<InfluencerVideo> videos;

  InfluencerVideoPaginatedResponse({
    required this.influencerId,
    required this.influencerName,
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.totalVideos,
    required this.videos,
  });

  factory InfluencerVideoPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return InfluencerVideoPaginatedResponse(
      influencerId: json['influencer_id'],
      influencerName: json['influencer_name'],
      currentPage: json['current_page'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
      totalVideos: json['total_videos'],
      videos: (json['videos'] as List)
          .map((e) => InfluencerVideo.fromJson(e))
          .toList(),
    );
  }
}
