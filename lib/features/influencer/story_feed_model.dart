class StoryFeed {
  final int id;
  final String influencerName;
  final String channelName;
  final String channelId;
  final String lastUploadedVideo;
  final DateTime lastUploadedDate;
  final bool viewed;
  final String channelProfilePic;

  StoryFeed({
    required this.id,
    required this.influencerName,
    required this.channelName,
    required this.channelId,
    required this.lastUploadedVideo,
    required this.lastUploadedDate,
    required this.viewed,
    required this.channelProfilePic,
  });

  factory StoryFeed.fromJson(Map<String, dynamic> json) {
    return StoryFeed(
      id: json['id'],
      influencerName: json['influencer_name'],
      channelName: json['channel_name'],
      channelId: json['channel_id'],
      lastUploadedVideo: json['last_uploaded_video'],
      lastUploadedDate: DateTime.parse(json['last_uploaded_date']),
      viewed: json['viewed'],
      channelProfilePic: json['channel_profile_pic'],
    );
  }
}
