import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/child_repository.dart';
import '../repositories/plan_repository.dart';
import '../repositories/notes_repository.dart';
import 'app_providers.dart';

final childRepositoryProvider = Provider<ChildRepository>(
  (ref) => ChildRepository(ref.read(firestoreProvider)),
);
final planRepositoryProvider = Provider<PlanRepository>(
  (ref) => PlanRepository(ref.read(firestoreProvider)),
);
final notesRepositoryProvider = Provider<NotesRepository>(
  (ref) => NotesRepository(ref.read(firestoreProvider)),
);
