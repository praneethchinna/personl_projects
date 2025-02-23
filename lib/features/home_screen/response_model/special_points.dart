class SpecialPoints {
  final String actionType;
  final int points;
  SpecialPoints({required this.actionType, required this.points});

  factory SpecialPoints.fromJson(Map<String, dynamic> json) => SpecialPoints(
        actionType: json["action_type"] ?? "",
        points: json["points"] ?? 0,
      );
}

const jsonData = [
  {"action_type": "Comment", "points": 20},
  {"action_type": "Facebook", "points": 20},
  {"action_type": "Twitter/X", "points": 20},
  {"action_type": "WhatsApp", "points": 25},
  {"action_type": "Instagram", "points": 25},
  {"action_type": "Snapchat", "points": 25},
  {"action_type": "Other", "points": 25},
  {"action_type": "Voting", "points": 25},
  {"action_type": "Like", "points": 15}
];
