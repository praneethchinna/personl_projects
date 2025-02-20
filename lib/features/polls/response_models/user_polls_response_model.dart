class UserPollsResponseModel {
  List<Poll> polls;

  UserPollsResponseModel({required this.polls});

  factory UserPollsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserPollsResponseModel(
      polls: List<Poll>.from(json["polls"].map((x) => Poll.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "polls": List<dynamic>.from(polls.map((x) => x.toJson())),
    };
  }
}

class Poll {
  int id;
  String question;
  List<String> options;
  List<int> votes;
  DateTime createdAt;
  List<int> regionIds;
  String postForAll;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.votes,
    required this.createdAt,
    required this.regionIds,
    required this.postForAll,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json["id"],
      question: json["question"],
      options: List<String>.from(json["options"].map((x) => x)),
      votes: List<int>.from(json["votes"].map((x) => x)),
      createdAt: DateTime.parse(json["created_at"]),
      regionIds: List<int>.from(json["region_ids"].map((x) => x)),
      postForAll: json["post_for_all"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "options": List<dynamic>.from(options.map((x) => x)),
      "votes": List<dynamic>.from(votes.map((x) => x)),
      "created_at": createdAt.toIso8601String(),
      "region_ids": List<dynamic>.from(regionIds.map((x) => x)),
      "post_for_all": postForAll,
    };
  }
}
