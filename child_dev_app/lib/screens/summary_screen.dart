import 'package:flutter/material.dart';
import '../models/weekly_plan.dart';
import 'package:go_router/go_router.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final plan = extra?['plan'] as WeeklyPlan?;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: plan == null
            ? const Text('No summary available')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Completed goals: ${(plan.progress * 100).toStringAsFixed(0)}%'),
                  const SizedBox(height: 12),
                  const Text('Why these matter:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('- Physical play supports motor and brain development.'),
                ],
              ),
      ),
    );
  }
}
