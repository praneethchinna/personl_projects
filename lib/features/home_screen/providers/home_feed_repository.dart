import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/repository/home_feeds_repo_impl.dart';
import 'package:ysr_project/features/home_screen/response_model/home_feeds_response_model.dart';
import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';
import 'package:ysr_project/features/home_screen/view_model/home_view_model.dart';
import 'package:ysr_project/services/user/user_data.dart';

final homeFeedNotifierProvider =
    StateNotifierProvider<HomeFeedNotifer, HomeViewModel>(
  (ref) {
    return HomeFeedNotifer(
        homeFeedsRepoImpl: ref.read(homeFeedRepoProvider), ref: ref);
  },
);

class HomeFeedNotifer extends StateNotifier<HomeViewModel> {
  bool _hasMore = true;
  int _page = 1;
  List<HomeFeedViewModel> homeFeedViewModels = [];
  final HomeFeedsRepoImpl homeFeedsRepoImpl;
  final Ref ref;
  HomeFeedNotifer({required this.homeFeedsRepoImpl, required this.ref})
      : super(HomeViewModel(
            isLoading: true, isError: false, homeFeedViewModels: [])) {
    getHomeFeeds();
  }

  Future<void> getHomeFeeds() async {
    try {
      final homeFeeds = await homeFeedsRepoImpl.getHomeFeeds();
      _hasMore = homeFeeds.hasNext;
      for (var element in homeFeeds.homeFeedResponseModelList) {
        homeFeedViewModels.add(updateFromResponseModel(element));
      }
      state = state.copyWith(
          isLoading: false,
          isError: false,
          homeFeedViewModels: homeFeedViewModels);
    } on Exception {
      state = state
          .copyWith(isLoading: false, isError: true, homeFeedViewModels: []);
    }
  }

  Future<void> getMoreHomeFeeds() async {
    if (!_hasMore) return;
    try {
      _page++;
      final homeFeeds = await homeFeedsRepoImpl.getHomeFeeds(page: _page);
      _hasMore = homeFeeds.hasNext;
      for (var element in homeFeeds.homeFeedResponseModelList) {
        homeFeedViewModels.add(updateFromResponseModel(element));
      }
      state = state.copyWith(
          isLoading: false,
          isError: false,
          homeFeedViewModels: homeFeedViewModels);
    } on Exception {
      state = state
          .copyWith(isLoading: false, isError: true, homeFeedViewModels: []);
    }
  }

  HomeFeedViewModel updateFromResponseModel(
      HomeFeedsResponseModel responseModel) {
    return HomeFeedViewModel(
        isSaved: responseModel.saved,
        batchId: responseModel.batchId,
        likeCount: responseModel.likeCount,
        likedUsers: List<int?>.from(responseModel.likedUsers),
        createdBy: responseModel.createdBy,
        description: responseModel.description,
        postedDate: responseModel.postedDate,
        editedBy: responseModel.editedBy,
        editedTime: responseModel.editedTime,
        region: responseModel.region,
        media: responseModel.media
            .map(
                (m) => MediaViewModel(fileUrl: m.fileUrl, fileType: m.fileType))
            .toList(),
        commentCount: responseModel.commentCount,
        commentedUsers: List<int?>.from(responseModel.commentedUsers),
        shareCount: responseModel.shareCount,
        comments: responseModel.comments
            .map((c) => CommentViewModel(
                  commentDate: c.commentDate,
                  commentText: c.commentText,
                  userId: c.userId,
                  userName: c.userName,
                ))
            .toList(),
        postType: responseModel.postType,
        pinnedPost: responseModel.pinnedPost);
  }

  void updateComments(int index, String comment) {
    final comments =
        List<CommentViewModel>.from(state.homeFeedViewModels[index].comments);
    comments.add(CommentViewModel(
      commentDate: DateTime.now(),
      commentText: comment,
      userId: ref.read(userProvider).userId,
      userName: ref.read(userProvider).name,
    ));
    final List<HomeFeedViewModel> newHomeFeedViewModels =
        List<HomeFeedViewModel>.from(state.homeFeedViewModels);
    newHomeFeedViewModels[index] =
        state.homeFeedViewModels[index].copyWith(comments: comments);
    state = state.copyWith(homeFeedViewModels: newHomeFeedViewModels);
  }

  void toggleLike(int index) {
    final likedUsers =
        List<int?>.from(state.homeFeedViewModels[index].likedUsers);
    final userId = ref.read(userProvider).userId;
    if (likedUsers.contains(userId)) {
      likedUsers.remove(userId);
    } else {
      likedUsers.add(userId);
    }
    final List<HomeFeedViewModel> newHomeFeedViewModels =
        List<HomeFeedViewModel>.from(state.homeFeedViewModels);
    newHomeFeedViewModels[index] =
        state.homeFeedViewModels[index].copyWith(likedUsers: likedUsers);
    state = state.copyWith(homeFeedViewModels: newHomeFeedViewModels);
  }

  void toggleSave(int index) {
    final List<HomeFeedViewModel> newHomeFeedViewModels =
        List<HomeFeedViewModel>.from(state.homeFeedViewModels);
    newHomeFeedViewModels[index] = state.homeFeedViewModels[index]
        .copyWith(isSaved: !state.homeFeedViewModels[index].isSaved);
    state = state.copyWith(homeFeedViewModels: newHomeFeedViewModels);
  }
}
