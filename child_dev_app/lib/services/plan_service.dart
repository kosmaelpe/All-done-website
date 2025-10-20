import 'package:uuid/uuid.dart';

import '../models/child_profile.dart';
import '../models/weekly_goal.dart';
import '../models/weekly_plan.dart';
import '../models/enums.dart';

class PlanService {
  final _uuid = const Uuid();

  WeeklyPlan generateWeeklyPlan(ChildProfile child) {
    final List<WeeklyGoal> goals = [];

    // Baseline movement goal
    goals.add(
      WeeklyGoal(
        id: _uuid.v4(),
        title: 'Daily active play ${child.dailyLimits.minActivityMinutes} min',
        why: 'Physical activity builds motor skills and supports brain development.',
        daysCompleted: _daysMap(),
      ),
    );

    if (child.priorities.contains(ParentPriority.cognitive)) {
      goals.add(
        WeeklyGoal(
          id: _uuid.v4(),
          title: 'Puzzle or sorting game (10 min)',
          why: 'Problem-solving strengthens cognitive flexibility and working memory.',
          daysCompleted: _daysMap(['mon', 'wed', 'fri']),
        ),
      );
    }

    if (child.priorities.contains(ParentPriority.creativity)) {
      goals.add(
        WeeklyGoal(
          id: _uuid.v4(),
          title: 'Art time (15 min)',
          why: 'Creative expression supports language and emotional development.',
          daysCompleted: _daysMap(['tue', 'thu', 'sat']),
        ),
      );
    }

    if (child.priorities.contains(ParentPriority.emotional)) {
      goals.add(
        WeeklyGoal(
          id: _uuid.v4(),
          title: 'Feelings check-in',
          why: 'Labeling emotions improves self-regulation and empathy.',
          daysCompleted: _daysMap(['mon', 'wed', 'sun']),
        ),
      );
    }

    if (child.priorities.contains(ParentPriority.physical)) {
      goals.add(
        WeeklyGoal(
          id: _uuid.v4(),
          title: 'Balance/coordination game',
          why: 'Gross motor practice refines balance and spatial awareness.',
          daysCompleted: _daysMap(['tue', 'thu', 'sat']),
        ),
      );
    }

    // Trim to 3–5 goals
    while (goals.length > 5) {
      goals.removeLast();
    }

    return WeeklyPlan(id: _uuid.v4(), weekStart: _mondayOf(DateTime.now()), goals: goals);
  }
}

Map<String, bool> _daysMap([List<String>? activeDays]) {
  const keys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  final set = activeDays?.toSet() ?? keys.toSet();
  return {for (final k in keys) k: set.contains(k) ? false : false};
}

DateTime _mondayOf(DateTime date) {
  return date
      .subtract(Duration(days: (date.weekday + 6) % 7))
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
}
