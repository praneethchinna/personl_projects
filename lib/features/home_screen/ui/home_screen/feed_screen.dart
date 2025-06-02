import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';
import 'package:ysr_project/features/home_screen/widgets/home_feed_widget.dart';

class HomeFeedList extends ConsumerStatefulWidget {
  const HomeFeedList({super.key});

  @override
  _HomeFeedListState createState() => _HomeFeedListState();
}

class _HomeFeedListState extends ConsumerState<HomeFeedList> {
  final _controller = SuperTooltipController();
  String _currentUrl = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeFeedNotifierProvider);

    return switch (true) {
      _ when viewModel.isLoading => Expanded(
          child: Skeletonizer(effect: ShimmerEffect(baseColor: Colors.grey,highlightColor: Colors.white),
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
              itemCount: 2,
            ),
          ),
        ),
      _ when viewModel.isError => Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sorry Something went wrong"),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(homeFeedNotifierProvider);
                    ref.invalidate(futurePointsProvider);
                  },
                  child: Text("Refresh"),
                )
              ],
            ),
          ),
        ),
      _ => Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              ref.invalidate(homeFeedNotifierProvider);
            },
            child: ListView.builder(
              itemCount: viewModel.homeFeedViewModels.length,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              itemBuilder: (context, index) {
                final item = viewModel.homeFeedViewModels[index];
                bool isVideo = item.media.first.fileType.contains("video");

                _currentUrl = item.media.first.fileUrl;
                final likedUsers =
                    item.likedUsers.where((element) => element != null);

                return HomeFeedWidget(
                    item: item,
                    index: index,
                    isVideo: isVideo,
                    likedUsers: likedUsers);
              },
            ),
          ),
        )
    };
  }
}
