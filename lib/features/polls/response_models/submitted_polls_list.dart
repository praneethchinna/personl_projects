class SubmittedPollsResponseModel {
  List<Poll>? polls;

  SubmittedPollsResponseModel({this.polls});

  SubmittedPollsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['voted_polls'] != null) {
      polls = <Poll>[];
      json['voted_polls'].forEach((v) {
        polls!.add(Poll.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (polls != null) {
      data['voted_polls'] = polls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Poll {
  int? pollId;
  String? option;

  Poll({this.pollId, this.option});

  Poll.fromJson(Map<String, dynamic> json) {
    pollId = json['poll_id'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['poll_id'] = this.pollId;
    data['option'] = this.option;
    return data;
  }
}
