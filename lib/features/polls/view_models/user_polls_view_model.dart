class UserPollsViewModel {
  List<PollViewModel> polls;
  final bool isLoading;
  final String isError;

  UserPollsViewModel(
      {required this.polls, required this.isLoading, required this.isError});

  UserPollsViewModel copyWith({
    List<PollViewModel>? polls,
    bool? isLoading,
    String? isError,
  }) {
    return UserPollsViewModel(
      polls: polls ?? this.polls,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }
}

class PollViewModel {
  String? selectedOption;
  int id;
  String question;
  List<String> options;
  List<int> votes;
  DateTime createdAt;
  List<int> regionIds;
  String postForAll;
  bool enableSubmit;

  PollViewModel(
      {this.selectedOption,
      required this.id,
      required this.question,
      required this.options,
      required this.votes,
      required this.createdAt,
      required this.regionIds,
      required this.postForAll,
      this.enableSubmit = true});

  PollViewModel copyWith({
    String? selectedOption,
    int? id,
    String? question,
    List<String>? options,
    List<int>? votes,
    DateTime? createdAt,
    List<int>? regionIds,
    String? postForAll,
    bool? enableSubmit,
  }) {
    return PollViewModel(
      selectedOption: selectedOption ?? this.selectedOption,
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      votes: votes ?? this.votes,
      createdAt: createdAt ?? this.createdAt,
      regionIds: regionIds ?? this.regionIds,
      postForAll: postForAll ?? this.postForAll,
      enableSubmit: enableSubmit ?? this.enableSubmit,
    );
  }
}
