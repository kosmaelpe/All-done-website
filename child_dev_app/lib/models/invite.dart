import 'enums.dart';

class Invite {
  final String id;
  final String email;
  final String code;
  final ParentRole role;
  final DateTime createdAt;

  const Invite({
    required this.id,
    required this.email,
    required this.code,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'email': email,
    'code': code,
    'role': role.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Invite.fromMap(String id, Map<String, dynamic> map) => Invite(
    id: id,
    email: map['email'] ?? '',
    code: map['code'] ?? '',
    role: ParentRole.values.firstWhere(
      (r) => r.name == (map['role'] ?? 'notesOnly'),
      orElse: () => ParentRole.notesOnly,
    ),
    createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
  );
}
