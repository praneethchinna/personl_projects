import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';

class SavedPostsViewModel {
  final bool isLoading;
  final bool isError;
  final List<HomeFeedViewModel> savedPosts;

  SavedPostsViewModel({
    required this.isLoading,
    required this.isError,
    required this.savedPosts,
  });

  SavedPostsViewModel copyWith({
    bool? isLoading,
    bool? isError,
    List<HomeFeedViewModel>? savedPosts,
  }) {
    return SavedPostsViewModel(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      savedPosts: savedPosts ?? this.savedPosts,
    );
  }
}
