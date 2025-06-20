class NotificationModel {
  final int id;
  final String source;
  final String text;
  final String postType;
  final String refId;
  final String createdAt;
  final bool viewed;

  NotificationModel({
    required this.id,
    required this.source,
    required this.text,
    required this.postType,
    required this.refId,
    required this.createdAt,
    required this.viewed,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      source: json['source'] as String,
      text: json['text'] as String,
      postType: json['post_type'] as String,
      refId: json['ref_id'] as String,
      createdAt: json['created_at'] as String,
      viewed: json['viewed'] as bool,
    );
  }

  NotificationModel copyWith({
    int? id,
    String? source,
    String? text,
    String? postType,
    String? refId,
    String? createdAt,
    bool? viewed,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      source: source ?? this.source,
      text: text ?? this.text,
      postType: postType ?? this.postType,
      refId: refId ?? this.refId,
      createdAt: createdAt ?? this.createdAt,
      viewed: viewed ?? this.viewed,
    );
  }
}

class NotificationResponse {
  final int page;
  final int pageSize;
  final int totalNotifications;
  final int totalPages;
  final bool hasNext;
  final List<NotificationModel> notifications;

  NotificationResponse({
    required this.page,
    required this.pageSize,
    required this.totalNotifications,
    required this.totalPages,
    required this.hasNext,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      totalNotifications: json['total_notifications'] as int,
      totalPages: json['total_pages'] as int,
      hasNext: json['has_next'] as bool,
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
