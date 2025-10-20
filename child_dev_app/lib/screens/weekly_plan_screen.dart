import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/weekly_plan.dart';
import '../models/child_profile.dart';

class WeeklyPlanScreen extends StatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  WeeklyPlan? _plan;
  ChildProfile? _child;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Plan')),
      body: plan == null
          ? const Center(child: Text('No plan. Please complete onboarding.'))
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  LinearProgressIndicator(value: plan.progress),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: plan.goals.length,
                      itemBuilder: (context, index) {
                        final goal = plan.goals[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(goal.title, style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 4),
                                Text(goal.why, style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
                                      .map(
                                        (d) => FilterChip(
                                          label: Text(d.toUpperCase()),
                                          selected: goal.daysCompleted[d] ?? false,
                                          onSelected: (_) {
                                            setState(() {
                                              plan.goals[index] = goal.toggleDay(d);
                                            });
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              context.go('/dashboard', extra: {'child': _child, 'plan': plan}),
                          child: const Text('Go to Child Dashboard'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              context.go('/summary', extra: {'child': _child, 'plan': plan}),
                          child: const Text('Weekly Summary'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
