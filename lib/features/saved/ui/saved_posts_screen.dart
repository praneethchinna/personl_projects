import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';
import 'package:ysr_project/features/home_screen/widgets/home_feed_widget.dart';
import 'package:ysr_project/features/saved/providers/saved_posts_repository.dart';
import 'package:ysr_project/features/saved/view_model/saved_posts_view_model.dart';
import 'package:ysr_project/features/saved/widgets/savedFeedWidget.dart';

class SavedPostsScreen extends ConsumerWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedState = ref.watch(savedPostsNotifierProvider);
    final notifier = ref.read(savedPostsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBody(savedState, notifier, context),
      ),
    );
  }

  Widget _buildBody(SavedPostsViewModel state, SavedPostsNotifier notifier,
      BuildContext context) {
    if (state.isLoading && state.savedPosts.isEmpty) {
      return _buildLoadingState();
    }

    if (state.isError) {
      return _buildErrorState(notifier);
    }

    if (state.savedPosts.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSavedPostsList(state, notifier);
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final dummyPost = HomeFeedViewModel.dummy();
          return HomeFeedWidget(
            item: dummyPost,
            index: index,
            isVideo: index.isEven,
            likedUsers: const [1, 2, 3],
          );
        },
        itemCount: 5,
      ),
    );
  }

  Widget _buildErrorState(SavedPostsNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Failed to load saved posts"),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              notifier.getSavedPosts();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No saved posts yet"),
    );
  }

  Widget _buildSavedPostsList(
      SavedPostsViewModel state, SavedPostsNotifier notifier) {
    return RefreshIndicator(
      onRefresh: () async {
        await notifier.getSavedPosts();
      },
      child: ListView.builder(
        itemCount: state.savedPosts.length,
        itemBuilder: (context, index) {
          final post = state.savedPosts[index];
          final isVideo = post.media.isNotEmpty &&
              post.media.first.fileType.contains('video');
          final likedUsers = post.likedUsers.where((user) => user != null);

          return SavedFeedWidget(
            item: post,
            index: index,
            isVideo: isVideo,
            likedUsers: likedUsers,
          );
        },
      ),
    );
  }

  bool _hasMore(SavedPostsViewModel state) {
    // Implement your logic to determine if there are more posts to load
    // This should match the logic in your notifier
    return true; // Placeholder
  }
}
