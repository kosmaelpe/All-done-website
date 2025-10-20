import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/weekly_plan.dart';
import '../models/child_profile.dart';

class ChildDashboardScreen extends StatefulWidget {
  const ChildDashboardScreen({super.key});

  @override
  State<ChildDashboardScreen> createState() => _ChildDashboardScreenState();
}

class _ChildDashboardScreenState extends State<ChildDashboardScreen> {
  WeeklyPlan? _plan;
  ChildProfile? _child;
  String _mood = '🙂';
  final String _tip = 'Take a 5-minute dance break!';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra != null && _plan == null) {
      setState(() {
        _child = extra['child'] as ChildProfile?;
        _plan = extra['plan'] as WeeklyPlan?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    final todaysKey = _dayKey(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text("${_child?.name ?? 'Child'}'s Dashboard")),
      body: plan == null
          ? const Center(child: Text('No plan available'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Mood:'),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _mood,
                        items: const ['😀', '🙂', '😐', '😕', '😴']
                            .map(
                              (m) => DropdownMenuItem(
                                value: m,
                                child: Text(m, style: TextStyle(fontSize: 24)),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _mood = v ?? '🙂'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Tip of the day: $_tip'),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: plan.goals.map((g) {
                        final done = g.daysCompleted[todaysKey] ?? false;
                        return CheckboxListTile(
                          title: Text(g.title),
                          subtitle: Text('Today'),
                          value: done,
                          onChanged: (_) => setState(() {
                            final i = plan.goals.indexOf(g);
                            plan.goals[i] = g.toggleDay(todaysKey);
                          }),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

String _dayKey(DateTime d) {
  const keys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  return keys[(d.weekday + 6) % 7];
}
