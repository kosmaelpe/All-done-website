import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/child_profile.dart';
import '../models/note.dart';
import '../models/weekly_plan.dart';
import 'app_providers.dart';

class ChildState extends Notifier<ChildProfile?> {
  @override
  ChildProfile? build() => null;

  void set(ChildProfile profile) => state = profile;
}

class PlanState extends Notifier<WeeklyPlan?> {
  @override
  WeeklyPlan? build() => null;

  void set(WeeklyPlan? plan) => state = plan;
}

class NotesState extends Notifier<List<NoteEntry>> {
  @override
  List<NoteEntry> build() => <NoteEntry>[];

  void add(NoteEntry note) => state = [note, ...state];
}

final childStateProvider = NotifierProvider<ChildState, ChildProfile?>(ChildState.new);
final planStateProvider = NotifierProvider<PlanState, WeeklyPlan?>(PlanState.new);
final notesStateProvider = NotifierProvider<NotesState, List<NoteEntry>>(NotesState.new);

final generatePlanProvider = Provider<WeeklyPlan?>((ref) {
  final child = ref.watch(childStateProvider);
  if (child == null) return null;
  final service = ref.watch(planServiceProvider);
  return service.generateWeeklyPlan(child);
});
