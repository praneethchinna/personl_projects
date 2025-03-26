class InfluencerVideoResponseModel {
  final String title;
  final String url;
  final DateTime publishedAt;
  final String channelName;

  const InfluencerVideoResponseModel({
    required this.title,
    required this.url,
    required this.publishedAt,
    required this.channelName,
  });

  factory InfluencerVideoResponseModel.fromJson(Map<String, dynamic> json) {
    return InfluencerVideoResponseModel(
      title: json['title'],
      url: json['url'],
      publishedAt: DateTime.parse(json['published_at']),
      channelName: json['channel_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'publishedAt': publishedAt,
      'channelName': channelName,
    };
  }
}
