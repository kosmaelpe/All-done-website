import 'weekly_goal.dart';

class WeeklyPlan {
  final String id;
  final DateTime weekStart; // Monday
  final List<WeeklyGoal> goals;

  const WeeklyPlan({required this.id, required this.weekStart, required this.goals});

  double get progress {
    if (goals.isEmpty) return 0;
    final ratios = goals.map((g) => g.completionRatio).toList();
    return ratios.reduce((a, b) => a + b) / goals.length;
  }

  Map<String, dynamic> toMap() => {
    'weekStart': weekStart.toIso8601String(),
    'goals': {for (final g in goals) g.id: g.toMap()},
  };

  factory WeeklyPlan.fromMap(String id, Map<String, dynamic> map) {
    final goalsMap = Map<String, dynamic>.from(map['goals'] ?? {});
    return WeeklyPlan(
      id: id,
      weekStart: DateTime.tryParse(map['weekStart'] ?? '') ?? _mondayOf(DateTime.now()),
      goals: goalsMap.entries
          .map((e) => WeeklyGoal.fromMap(e.key, Map<String, dynamic>.from(e.value)))
          .toList(),
    );
  }
}

DateTime _mondayOf(DateTime date) {
  return date
      .subtract(Duration(days: (date.weekday + 6) % 7))
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
}
