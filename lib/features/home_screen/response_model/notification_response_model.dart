class NotificationResponseModel {
  List<LatestVideo> latestVideos;

  NotificationResponseModel({required this.latestVideos});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      latestVideos: List<LatestVideo>.from(
        json["latest_videos"].map((x) => LatestVideo.fromJson(x)),
      ),
    );
  }
}

class LatestVideo {
  String title;
  String url;
  DateTime publishedAt;

  LatestVideo(
      {required this.title, required this.url, required this.publishedAt});

  factory LatestVideo.fromJson(Map<String, dynamic> json) {
    return LatestVideo(
      title: json["title"],
      url: json["url"],
      publishedAt: DateTime.parse(json["published_at"]),
    );
  }
}
