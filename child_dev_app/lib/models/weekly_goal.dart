class WeeklyGoal {
  final String id;
  final String title;
  final String why;
  final Map<String, bool> daysCompleted; // keys: mon..sun

  const WeeklyGoal({
    required this.id,
    required this.title,
    required this.why,
    required this.daysCompleted,
  });

  int get completedDaysCount => daysCompleted.values.where((v) => v).length;

  double get completionRatio =>
      daysCompleted.isEmpty ? 0 : completedDaysCount / daysCompleted.length;

  WeeklyGoal toggleDay(String dayKey) => WeeklyGoal(
    id: id,
    title: title,
    why: why,
    daysCompleted: {...daysCompleted, dayKey: !(daysCompleted[dayKey] ?? false)},
  );

  Map<String, dynamic> toMap() => {'title': title, 'why': why, 'daysCompleted': daysCompleted};

  factory WeeklyGoal.fromMap(String id, Map<String, dynamic> map) => WeeklyGoal(
    id: id,
    title: map['title'] ?? '',
    why: map['why'] ?? '',
    daysCompleted: Map<String, bool>.from(map['daysCompleted'] ?? {}),
  );
}
