import 'dart:convert';

class SpecialVideos {
  String title;
  String videoUrl;
  String description;
  int id;
  int createdBy;
  DateTime createdTime;
  int updatedBy;
  DateTime updatedTime;

  SpecialVideos({
    required this.title,
    required this.videoUrl,
    required this.description,
    required this.id,
    required this.createdBy,
    required this.createdTime,
    required this.updatedBy,
    required this.updatedTime,
  });

  factory SpecialVideos.fromJson(Map<String, dynamic> json) {
    return SpecialVideos(
      title: json['title'],
      videoUrl: json['video_url'],
      description: json['description'],
      id: json['id'],
      createdBy: json['created_by'],
      createdTime: DateTime.parse(json['created_time']),
      updatedBy: json['updated_by'],
      updatedTime: DateTime.parse(json['updated_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'video_url': videoUrl,
      'description': description,
      'id': id,
      'created_by': createdBy,
      'created_time': createdTime.toIso8601String(),
      'updated_by': updatedBy,
      'updated_time': updatedTime.toIso8601String(),
    };
  }
}

List<SpecialVideos> videoListFromJson(String str) {
  return List<SpecialVideos>.from(json.decode(str).map((x) => SpecialVideos.fromJson(x)));
}

String videoListToJson(List<SpecialVideos> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
