import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/response_model/home_feeds_response_model.dart';
import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';
import 'package:ysr_project/features/saved/providers/saved_posts_repo_provider.dart';
import 'package:ysr_project/features/saved/repository/saved_posts_repo_impl.dart';
import 'package:ysr_project/features/saved/view_model/saved_posts_view_model.dart';
import 'package:ysr_project/services/user/user_data.dart';

final savedPostsNotifierProvider =
    StateNotifierProvider.autoDispose<SavedPostsNotifier, SavedPostsViewModel>(
  (ref) {
    return SavedPostsNotifier(
        savedPostsRepo: ref.read(savedPostsRepoProvider), ref: ref);
  },
);

class SavedPostsNotifier extends StateNotifier<SavedPostsViewModel> {
  bool _hasMore = true;
  int _page = 1;
  final Ref ref;
  final SavedPostsRepoImpl savedPostsRepo;
  List<HomeFeedViewModel> savedPosts = [];

  SavedPostsNotifier({
    required this.ref,
    required this.savedPostsRepo,
  }) : super(SavedPostsViewModel(
          isLoading: true,
          isError: false,
          savedPosts: [],
        )) {
    getSavedPosts();
  }

  Future<void> getSavedPosts() async {
    try {
      savedPosts = [];
      state = state.copyWith(isLoading: true, isError: false, savedPosts: []);
      final savedPostsResponse = await savedPostsRepo.getSavedPosts();

      // Convert response models to view models
      final newSavedPosts = savedPostsResponse
          .map((post) => _updateFromResponseModel(post))
          .toList();

      savedPosts.addAll(newSavedPosts);

      state = state.copyWith(
        isLoading: false,
        isError: false,
        savedPosts: savedPosts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        savedPosts: [],
      );
    }
  }

  Future<void> loadMoreSavedPosts() async {
    if (!_hasMore) return;

    try {
      _page++;
      final savedPostsResponse =
          await savedPostsRepo.getSavedPosts(page: _page);

      final newSavedPosts = savedPostsResponse
          .map((post) => _updateFromResponseModel(post))
          .toList();

      savedPosts.addAll(newSavedPosts);

      state = state.copyWith(
        savedPosts: savedPosts,
      );
    } catch (e) {
      // Handle error, maybe revert page counter
      _page--;
      rethrow;
    }
  }

  void toggleLike(int index) {
    final likedUsers = List<int?>.from(state.savedPosts[index].likedUsers);
    final userId = ref.read(userProvider).userId;

    if (likedUsers.contains(userId)) {
      likedUsers.remove(userId);
    } else {
      likedUsers.add(userId);
    }

    final newSavedPosts = List<HomeFeedViewModel>.from(state.savedPosts);
    newSavedPosts[index] = state.savedPosts[index].copyWith(
      likedUsers: likedUsers,
      likeCount: state.savedPosts[index].likeCount +
          (likedUsers.contains(userId) ? 1 : -1),
    );

    state = state.copyWith(savedPosts: newSavedPosts);
  }

  void toggleSave(int index) {
    final newSavedPosts = List<HomeFeedViewModel>.from(state.savedPosts);
    newSavedPosts[index] = newSavedPosts[index].copyWith(
      isSaved: !newSavedPosts[index].isSaved,
    );

    // Remove the post from the list if unsaved
    if (!newSavedPosts[index].isSaved) {
      newSavedPosts.removeAt(index);
    }

    state = state.copyWith(savedPosts: newSavedPosts);
  }

  void updateComments(int index, String comment) {
    final comments =
        List<CommentViewModel>.from(state.savedPosts[index].comments);
    comments.add(CommentViewModel(
      commentDate: DateTime.now(),
      commentText: comment,
      userId: ref.read(userProvider).userId,
      userName: ref.read(userProvider).name,
    ));

    final newSavedPosts = List<HomeFeedViewModel>.from(state.savedPosts);
    newSavedPosts[index] = state.savedPosts[index].copyWith(
      comments: comments,
      commentCount: state.savedPosts[index].commentCount + 1,
    );

    state = state.copyWith(savedPosts: newSavedPosts);
  }

  HomeFeedViewModel _updateFromResponseModel(HomeFeedsResponseModel model) {
    return HomeFeedViewModel(
      isSaved: true, // All posts here are saved by definition
      batchId: model.batchId,
      likeCount: model.likeCount,
      likedUsers: List<int?>.from(model.likedUsers),
      createdBy: model.createdBy,
      description: model.description,
      postedDate: model.postedDate,
      editedBy: model.editedBy,
      editedTime: model.editedTime,
      region: model.region,
      media: model.media
          .map((media) => MediaViewModel(
                fileUrl: media.fileUrl,
                fileType: media.fileType,
              ))
          .toList(),
      commentCount: model.commentCount,
      commentedUsers: List<int?>.from(model.commentedUsers),
      shareCount: model.shareCount,
      comments: model.comments
          .map((c) => CommentViewModel(
                commentDate: c.commentDate,
                commentText: c.commentText,
                userId: c.userId,
                userName: c.userName,
              ))
          .toList(),
      postType: model.postType,
      pinnedPost: model.pinnedPost,
    );
  }
}
