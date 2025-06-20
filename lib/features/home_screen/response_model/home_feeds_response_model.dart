class HomeFeedFullResponseModel {
  int page;
  int pageSize;
  int totalPosts;
  int totalPages;
  bool hasNext;

  List<HomeFeedsResponseModel> homeFeedResponseModelList;
  HomeFeedFullResponseModel({
    required this.page,
    required this.pageSize,
    required this.totalPosts,
    required this.totalPages,
    required this.hasNext,
    required this.homeFeedResponseModelList,
  });

  factory HomeFeedFullResponseModel.fromJson(Map<String, dynamic> json) =>
      HomeFeedFullResponseModel(
        page: json["page"],
        pageSize: json["page_size"],
        totalPosts: json["total_posts"],
        totalPages: json["total_pages"],
        hasNext: json["has_next"],
        homeFeedResponseModelList: (json["posts"] as List)
            .map((e) => HomeFeedsResponseModel.fromJson(e))
            .toList(),
      );
}

class HomeFeedsResponseModel {
  HomeFeedsResponseModel(
      {required this.batchId,
      required this.likeCount,
      required this.likedUsers,
      required this.createdBy,
      required this.description,
      required this.postedDate,
      required this.editedBy,
      required this.editedTime,
      required this.region,
      required this.media,
      required this.commentCount,
      required this.commentedUsers,
      required this.shareCount,
      required this.comments,
      required this.postType,
      required this.pinnedPost,
      required this.saved});

  factory HomeFeedsResponseModel.fromJson(Map<String, dynamic> json) =>
      HomeFeedsResponseModel(
          batchId: json["batch_id"] as String,
          likeCount: json["like_count"] as int,
          likedUsers: List<int?>.from(
              (json["liked_users"] ?? []).map((x) => x as int?)),
          createdBy: json["created_by"] as String,
          description: json["description"] as String,
          postedDate: DateTime.parse(json["posted_date"] as String),
          editedBy: json["edited_by"] as String?,
          editedTime: json["edited_time"] == null
              ? null
              : DateTime.parse(json["edited_time"] as String),
          region: json["region"] as String,
          media: List<Media>.from((json["media"] ?? [])
              .map((x) => Media.fromJson(x as Map<String, dynamic>))),
          commentCount: json["comment_count"] as int,
          commentedUsers: List<int?>.from(
              (json["commented_users"] ?? []).map((x) => x as int?)),
          shareCount: json["share_count"] as int,
          comments: List<Comment>.from((json["comments"] ?? [])
              .map((x) => Comment.fromJson(x as Map<String, dynamic>))),
          postType: json["post_type"] ?? "",
          pinnedPost: json["pinned_post"] ?? false,
          saved: json["saved"] ?? false);

  String batchId;
  int likeCount;
  List<int?> likedUsers;
  String createdBy;
  String description;
  DateTime postedDate;
  String? editedBy;
  DateTime? editedTime;
  String region;
  List<Media> media;
  int commentCount;
  List<int?> commentedUsers;
  int shareCount;
  List<Comment> comments;
  String postType;
  bool pinnedPost;
  bool saved;
}

class Media {
  Media({
    required this.fileUrl,
    required this.fileType,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        fileUrl: json["file_url"] as String,
        fileType: json["file_type"] as String,
      );

  String fileUrl;
  String fileType;
}

class Comment {
  Comment({
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.commentDate,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["user_id"] as int,
        userName: json["user_name"] as String? ?? "Anonymous",
        commentText: json["comment_text"] as String,
        commentDate: DateTime.parse(json["comment_date"] as String),
      );

  int userId;
  String userName;
  String commentText;
  DateTime commentDate;
}
