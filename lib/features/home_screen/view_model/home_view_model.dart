import 'package:ysr_project/features/home_screen/view_model/home_feed_view_model.dart';

class HomeViewModel {
  final bool isLoading;
  final bool isError;
  final List<HomeFeedViewModel> homeFeedViewModels;

  HomeViewModel(
      {required this.isLoading,
      required this.isError,
      required this.homeFeedViewModels});

  HomeViewModel copyWith({
    bool? isLoading,
    bool? isError,
    List<HomeFeedViewModel>? homeFeedViewModels,
  }) {
    return HomeViewModel(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      homeFeedViewModels: homeFeedViewModels ?? this.homeFeedViewModels,
    );
  }
}
