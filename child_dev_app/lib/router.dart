import 'package:go_router/go_router.dart';

import 'screens/onboarding_screen.dart';
import 'screens/weekly_plan_screen.dart';
import 'screens/child_dashboard_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/invite_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (ctx, st) => const OnboardingScreen()),
    GoRoute(path: '/plan', builder: (ctx, st) => const WeeklyPlanScreen()),
    GoRoute(path: '/dashboard', builder: (ctx, st) => const ChildDashboardScreen()),
    GoRoute(path: '/notes', builder: (ctx, st) => const NotesScreen()),
    GoRoute(path: '/summary', builder: (ctx, st) => const SummaryScreen()),
    GoRoute(path: '/settings', builder: (ctx, st) => const SettingsScreen()),
    GoRoute(path: '/invite', builder: (ctx, st) => const InviteScreen()),
  ],
);
