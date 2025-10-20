import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/enums.dart';
import '../models/child_profile.dart';
import '../providers/app_providers.dart';
import '../providers/state_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _age = 2;
  Temperament _temperament = Temperament.calm;
  final Set<ParentPriority> _priorities = {};
  int _screenTime = 60;
  int _sweets = 1;
  int _minActivity = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Setup')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Child Name'),
                onSaved: (v) => _name = v?.trim() ?? '',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Age:'),
                  const SizedBox(width: 12),
                  DropdownButton<int>(
                    value: _age,
                    items: List.generate(
                      10,
                      (i) => i + 2,
                    ).map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(),
                    onChanged: (v) => setState(() => _age = v ?? 2),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Temperament:'),
                  const SizedBox(width: 12),
                  DropdownButton<Temperament>(
                    value: _temperament,
                    items: Temperament.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.name[0].toUpperCase() + t.name.substring(1)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _temperament = v ?? Temperament.calm),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Parent Priorities'),
              Wrap(
                spacing: 8,
                children: ParentPriority.values.map((p) {
                  final selected = _priorities.contains(p);
                  return FilterChip(
                    label: Text(_priorityLabel(p)),
                    selected: selected,
                    onSelected: (_) => setState(() {
                      if (selected) {
                        _priorities.remove(p);
                      } else {
                        _priorities.add(p);
                      }
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text('Daily Limits'),
              _numField('Screen time (min)', _screenTime, (v) => _screenTime = v),
              const SizedBox(height: 8),
              _numField('Sweets per day', _sweets, (v) => _sweets = v),
              const SizedBox(height: 8),
              _numField('Min activity (min)', _minActivity, (v) => _minActivity = v),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  child: const Text('Generate Weekly Plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numField(String label, int initial, void Function(int) onChanged) {
    final controller = TextEditingController(text: '$initial');
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (v) => onChanged(int.tryParse(v) ?? initial),
    );
  }

  void _onContinue() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final child = ChildProfile(
      id: 'local',
      name: _name,
      ageYears: _age,
      temperament: _temperament,
      priorities: _priorities,
      dailyLimits: DailyLimits(
        screenTimeMinutes: _screenTime,
        sweetsPerDay: _sweets,
        minActivityMinutes: _minActivity,
      ),
      members: const {},
    );

    final planService = ref.read(planServiceProvider);
    final plan = planService.generateWeeklyPlan(child);
    ref.read(childStateProvider.notifier).set(child);
    ref.read(planStateProvider.notifier).set(plan);

    if (mounted) {
      if (context.canPop()) {
        context.pop();
      }
      context.go('/plan', extra: {'child': child, 'plan': plan});
    }
  }
}

String _priorityLabel(ParentPriority p) {
  switch (p) {
    case ParentPriority.physical:
      return 'Physical Activity';
    case ParentPriority.cognitive:
      return 'Cognitive Skills';
    case ParentPriority.emotional:
      return 'Emotional Regulation';
    case ParentPriority.creativity:
      return 'Creativity';
  }
}
