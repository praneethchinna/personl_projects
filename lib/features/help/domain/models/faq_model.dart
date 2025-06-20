class FaqModel {
  final int id;
  final String question;
  final String answer;
  bool isExpanded;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  FaqModel copyWith({
    int? id,
    String? question,
    String? answer,
    bool? isExpanded,
  }) {
    return FaqModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }
}

class FaqResponse {

  final List<FaqModel> faqs;

  FaqResponse({

    required this.faqs,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    return FaqResponse(

      faqs: (json['faqs'] as List<dynamic>)
          .map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
