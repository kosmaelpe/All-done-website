import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/plan_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final firestoreProvider = Provider<FirestoreService>((ref) => FirestoreService());

final planServiceProvider = Provider<PlanService>((ref) => PlanService());
