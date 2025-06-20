class HomeFeedViewModel {
  HomeFeedViewModel(
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
      required this.isSaved});

  String batchId;
  int likeCount;
  List<int?> likedUsers;
  String createdBy;
  String description;
  DateTime postedDate;
  String? editedBy;
  DateTime? editedTime;
  String region;
  List<MediaViewModel> media;
  int commentCount;
  List<int?> commentedUsers;
  int shareCount;
  List<CommentViewModel> comments;
  String postType;
  bool pinnedPost;
  bool isSaved;

  HomeFeedViewModel copyWith(
          {String? batchId,
          int? likeCount,
          List<int?>? likedUsers,
          String? createdBy,
          String? description,
          DateTime? postedDate,
          String? editedBy,
          DateTime? editedTime,
          String? region,
          List<MediaViewModel>? media,
          int? commentCount,
          List<int?>? commentedUsers,
          int? shareCount,
          List<CommentViewModel>? comments,
          String? postType,
          bool? pinnedPost,
          bool? isSaved}) =>
      HomeFeedViewModel(
          isSaved: isSaved ?? this.isSaved,
          batchId: batchId ?? this.batchId,
          likeCount: likeCount ?? this.likeCount,
          likedUsers: likedUsers ?? this.likedUsers,
          createdBy: createdBy ?? this.createdBy,
          description: description ?? this.description,
          postedDate: postedDate ?? this.postedDate,
          editedBy: editedBy ?? this.editedBy,
          editedTime: editedTime ?? this.editedTime,
          region: region ?? this.region,
          media: media ?? this.media,
          commentCount: commentCount ?? this.commentCount,
          commentedUsers: commentedUsers ?? this.commentedUsers,
          shareCount: shareCount ?? this.shareCount,
          comments: comments ?? this.comments,
          postType: postType ?? this.postType,
          pinnedPost: pinnedPost ?? this.pinnedPost);

  static HomeFeedViewModel dummy() {
    return HomeFeedViewModel(
        isSaved: false,
        batchId: '',
        likeCount: 0,
        likedUsers: [],
        createdBy: '',
        description: '',
        postedDate: DateTime.now(),
        editedBy: '',
        editedTime: null,
        region: '',
        media: [],
        commentCount: 0,
        commentedUsers: [],
        shareCount: 0,
        comments: [],
        postType: '',
        pinnedPost: false);
  }
}

class MediaViewModel {
  MediaViewModel({
    required this.fileUrl,
    required this.fileType,
  });

  String fileUrl;
  String fileType;

  MediaViewModel copyWith({
    String? fileUrl,
    String? fileType,
  }) =>
      MediaViewModel(
        fileUrl: fileUrl ?? this.fileUrl,
        fileType: fileType ?? this.fileType,
      );
}

class CommentViewModel {
  CommentViewModel({
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.commentDate,
  });

  int userId;
  String userName;
  String commentText;
  DateTime commentDate;

  CommentViewModel copyWith({
    int? userId,
    String? userName,
    String? commentText,
    DateTime? commentDate,
  }) =>
      CommentViewModel(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        commentText: commentText ?? this.commentText,
        commentDate: commentDate ?? this.commentDate,
      );
}
