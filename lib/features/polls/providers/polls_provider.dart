import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/polls/repository/polls_respository_impl.dart';
import 'package:ysr_project/features/polls/response_models/submitted_polls_list.dart';
import 'package:ysr_project/features/polls/view_models/user_polls_view_model.dart';

final pollsProvider =
    StateNotifierProvider<PollsNotifer, UserPollsViewModel>((ref) {
  return PollsNotifer(
    ref.read(pollsRepositoryProvider),
  );
});

class PollsNotifer extends StateNotifier<UserPollsViewModel> {
  final PollsRepositoryImpl _pollsRepositoryImpl;
  PollsNotifer(this._pollsRepositoryImpl)
      : super(UserPollsViewModel(polls: [], isLoading: true, isError: "")) {
    fetchUserPolls();
  }
  Future<void> fetchUserPolls() async {
    try {
      final submittedPollsResponseModel =
          await _pollsRepositoryImpl.getSubmittedPolls();
      if (submittedPollsResponseModel.polls == null) {
        print("Submitted polls is null");
      }

      final userPollsResponseModel = await _pollsRepositoryImpl.getUserPolls();

      final polls = userPollsResponseModel.polls
          .map((e) => PollViewModel(
                id: e.id,
                question: e.question,
                options: e.options,
                votes: e.votes,
                createdAt: e.createdAt,
                regionIds: e.regionIds,
                postForAll: e.postForAll,
                selectedOption: submittedPollsResponseModel.polls!
                    .firstWhere(
                        (element) =>
                            element.pollId == e.id &&
                            e.options.contains(element.option),
                        orElse: () => Poll())
                    .option,
                enableSubmit: submittedPollsResponseModel.polls!.any(
                        (element) =>
                            element.pollId == e.id &&
                            e.options.contains(element.option))
                    ? true
                    : false,
              ))
          .toList();

      state = UserPollsViewModel(
        polls: polls,
        isLoading: false,
        isError: "",
      );
    } on Exception catch (e) {
      state = state.copyWith(
        polls: [],
        isLoading: false,
        isError: e.toString(),
      );
    }
  }

  void updateSelectedIndex(int indexId, String selectedOption) {
    state = state.copyWith(
      polls: [
        ...state.polls.sublist(0, indexId),
        state.polls[indexId].copyWith(selectedOption: selectedOption),
        ...state.polls.sublist(indexId + 1),
      ],
    );
  }
}
