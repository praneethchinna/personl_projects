import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loadmore/loadmore.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';
import 'package:ysr_project/features/home_screen/widgets/home_feed_widget.dart';
import 'package:ysr_project/features/influencer/influencer_providers.dart';
import 'package:ysr_project/services/user/user_data.dart';

class HomeFeedList extends ConsumerStatefulWidget {
  const HomeFeedList({super.key});

  @override
  _HomeFeedListState createState() => _HomeFeedListState();
}

class _HomeFeedListState extends ConsumerState<HomeFeedList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeFeedNotifierProvider);

    return Column(
      children: [
        if (viewModel.isLoading)
          Expanded(
            child: Skeletonizer(
              effect: ShimmerEffect(
                  baseColor: Colors.grey, highlightColor: Colors.white),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item = HomeFeedViewModel.dummy();
                  final isVideo = index.isEven;
                  final likedUsers = [1, 2, 3];
                  return HomeFeedWidget(
                    item: item,
                    index: index,
                    isVideo: isVideo,
                    likedUsers: likedUsers,
                  );
                },
                itemCount: 5, // Show more items for visual scroll
              ),
            ),
          )
        else if (viewModel.isError)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sorry, something went wrong"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(homeFeedNotifierProvider);
                      ref.invalidate(futurePointsProvider);
                    },
                    child: const Text("Refresh"),
                  )
                ],
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(homeFeedNotifierProvider);
                ref.invalidate(
                    storyFeedProvider(ref.read(userProvider).userId));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: LoadMore(
                  whenEmptyLoad: false,
                  isFinish: false,
                  onLoadMore: () async {
                    debugPrint("🔄 Load more triggered");
                    await ref
                        .read(homeFeedNotifierProvider.notifier)
                        .getMoreHomeFeeds();
                    return true;
                  },
                  delegate: const DefaultLoadMoreDelegate(),
                  textBuilder: DefaultLoadMoreTextBuilder.english,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    itemCount: viewModel.homeFeedViewModels.length,
                    itemBuilder: (context, index) {
                      final item = viewModel.homeFeedViewModels[index];
                      final isVideo =
                          item.media.first.fileType.contains("video");
                      final likedUsers =
                          item.likedUsers.where((element) => element != null);
                      return HomeFeedWidget(
                        item: item,
                        index: index,
                        isVideo: isVideo,
                        likedUsers: likedUsers,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
