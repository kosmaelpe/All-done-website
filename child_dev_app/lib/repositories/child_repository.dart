import '../models/child_profile.dart';
import '../services/firestore_service.dart';
import '../services/firebase_config.dart';
import '../firebase_options.dart';
import 'local_store.dart';

class ChildRepository {
  final FirestoreService firestore;

  ChildRepository(this.firestore);

  Future<void> saveProfile(String uid, ChildProfile profile) async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (FirebaseConfig.isConfigured(options)) {
      await firestore.instance.collection('children').doc(profile.id).set(profile.toMap());
    }
    await LocalStore.saveJson('child:$uid', profile.toMap());
  }

  Future<ChildProfile?> loadProfile(String uid, String childId) async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (FirebaseConfig.isConfigured(options)) {
      final snap = await firestore.instance.collection('children').doc(childId).get();
      if (snap.exists && snap.data() != null) {
        return ChildProfile.fromMap(snap.id, snap.data()!);
      }
    }
    final local = await LocalStore.readJson('child:$uid');
    if (local != null) {
      return ChildProfile.fromMap(childId, local);
    }
    return null;
  }
}
