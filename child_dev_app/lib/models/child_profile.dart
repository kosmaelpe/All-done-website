import 'enums.dart';

class DailyLimits {
  final int screenTimeMinutes;
  final int sweetsPerDay;
  final int minActivityMinutes;

  const DailyLimits({
    required this.screenTimeMinutes,
    required this.sweetsPerDay,
    required this.minActivityMinutes,
  });

  Map<String, dynamic> toMap() => {
    'screenTimeMinutes': screenTimeMinutes,
    'sweetsPerDay': sweetsPerDay,
    'minActivityMinutes': minActivityMinutes,
  };

  factory DailyLimits.fromMap(Map<String, dynamic> map) => DailyLimits(
    screenTimeMinutes: map['screenTimeMinutes'] ?? 0,
    sweetsPerDay: map['sweetsPerDay'] ?? 0,
    minActivityMinutes: map['minActivityMinutes'] ?? 0,
  );
}

class ChildProfile {
  final String id;
  final String name;
  final int ageYears;
  final Temperament temperament;
  final Set<ParentPriority> priorities;
  final DailyLimits dailyLimits;
  final Map<String, String> members; // uid -> role string

  const ChildProfile({
    required this.id,
    required this.name,
    required this.ageYears,
    required this.temperament,
    required this.priorities,
    required this.dailyLimits,
    required this.members,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'ageYears': ageYears,
    'temperament': temperament.name,
    'priorities': priorities.map((e) => e.name).toList(),
    'dailyLimits': dailyLimits.toMap(),
    'members': members,
  };

  factory ChildProfile.fromMap(String id, Map<String, dynamic> map) => ChildProfile(
    id: id,
    name: map['name'] ?? '',
    ageYears: map['ageYears'] ?? 2,
    temperament: Temperament.values.firstWhere(
      (t) => t.name == (map['temperament'] ?? 'calm'),
      orElse: () => Temperament.calm,
    ),
    priorities: ((map['priorities'] as List?) ?? [])
        .map(
          (e) => ParentPriority.values.firstWhere(
            (p) => p.name == e,
            orElse: () => ParentPriority.physical,
          ),
        )
        .toSet(),
    dailyLimits: map['dailyLimits'] != null
        ? DailyLimits.fromMap(Map<String, dynamic>.from(map['dailyLimits']))
        : const DailyLimits(screenTimeMinutes: 60, sweetsPerDay: 1, minActivityMinutes: 30),
    members: Map<String, String>.from(map['members'] ?? {}),
  );
}
