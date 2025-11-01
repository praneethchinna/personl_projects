class RewardsResponseModel {
  final int userId;
  final String name;
  final int totalPoints;
  final String currentLevel;
  final double levelCompletionPercentage;
  final List<Level> levels;

  RewardsResponseModel({
    required this.userId,
    required this.name,
    required this.totalPoints,
    required this.currentLevel,
    required this.levelCompletionPercentage,
    required this.levels,
  });

  factory RewardsResponseModel.fromJson(Map<String, dynamic> json) {
    return RewardsResponseModel(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      totalPoints: json['total_points'] as int,
      currentLevel: json['current_level'] as String,
      levelCompletionPercentage:
          (json['level_completion_percentage'] as num).toDouble(),
      levels: (json['levels'] as List<dynamic>)
          .map((level) => Level.fromJson(level as Map<String, dynamic>))
          .toList(),
    );
  }

  factory RewardsResponseModel.dummy() {
    return RewardsResponseModel(
      userId: 1,
      name: 'John Doe',
      totalPoints: 100,
      currentLevel: 'Level 1',
      levelCompletionPercentage: 50.0,
      levels: [
        Level(
          levelId: 1,
          level: 'Level 1',
          incentives: 'Test Incentives',
          notes: 'Test Notes',
          startPointRange: 1,
          endPointRange: 100,
          completed: true,
        ),
        Level(
          levelId: 2,
          level: 'Level 2',
          incentives: 'Test Incentives',
          notes: 'Test Notes',
          startPointRange: 101,
          endPointRange: 200,
          completed: false,
        ),
      ],
    );
  }
}

class Level {
  final int levelId;
  final String level;
  final String incentives;
  final String notes;
  final int startPointRange;
  final int endPointRange;
  final bool completed;

  Level({
    required this.levelId,
    required this.level,
    required this.incentives,
    required this.notes,
    required this.startPointRange,
    required this.endPointRange,
    required this.completed,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelId: json['level_id'] as int,
      level: json['level'] as String,
      incentives: json['incentives'] as String,
      notes: json['notes'] as String,
      startPointRange: json['start_point_range'] as int,
      endPointRange: json['end_point_range'] as int,
      completed: json['completed'] as bool,
    );
  }

  factory Level.dummy() {
    return Level(
      levelId: 1,
      level: 'Level 1',
      incentives: 'Test Incentives',
      notes: 'Test Notes',
      startPointRange: 1,
      endPointRange: 100,
      completed: true,
    );
  }
}
