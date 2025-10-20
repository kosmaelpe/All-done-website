import '../models/weekly_plan.dart';
import '../services/firestore_service.dart';
import '../services/firebase_config.dart';
import '../firebase_options.dart';
import 'local_store.dart';

class PlanRepository {
  final FirestoreService firestore;

  PlanRepository(this.firestore);

  Future<void> savePlan(String uid, WeeklyPlan plan) async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (FirebaseConfig.isConfigured(options)) {
      await firestore.instance
          .collection('users')
          .doc(uid)
          .collection('plans')
          .doc(plan.id)
          .set(plan.toMap());
    }
    await LocalStore.saveJson('plan:$uid:${plan.id}', plan.toMap());
  }

  Future<WeeklyPlan?> loadPlan(String uid, String planId) async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (FirebaseConfig.isConfigured(options)) {
      final doc = await firestore.instance
          .collection('users')
          .doc(uid)
          .collection('plans')
          .doc(planId)
          .get();
      if (doc.exists && doc.data() != null) {
        return WeeklyPlan.fromMap(doc.id, doc.data()!);
      }
    }
    final local = await LocalStore.readJson('plan:$uid:$planId');
    if (local != null) {
      return WeeklyPlan.fromMap(planId, local);
    }
    return null;
  }
}
