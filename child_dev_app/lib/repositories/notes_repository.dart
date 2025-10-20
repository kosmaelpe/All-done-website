import '../models/note.dart';
import '../services/firestore_service.dart';
import '../services/firebase_config.dart';
import '../firebase_options.dart';
import 'local_store.dart';

class NotesRepository {
  final FirestoreService firestore;

  NotesRepository(this.firestore);

  Future<void> addNote(String uid, String childId, NoteEntry note) async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (FirebaseConfig.isConfigured(options)) {
      await firestore.instance
          .collection('children')
          .doc(childId)
          .collection('notes')
          .doc(note.id)
          .set(note.toMap());
    }
    final list = await LocalStore.readList('notes:$childId');
    list.insert(0, note.toMap());
    await LocalStore.saveList('notes:$childId', list);
  }

  Future<List<NoteEntry>> fetchNotes(String childId) async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (FirebaseConfig.isConfigured(options)) {
      final snaps = await firestore.instance
          .collection('children')
          .doc(childId)
          .collection('notes')
          .orderBy('createdAt', descending: true)
          .get();
      return snaps.docs.map((d) => NoteEntry.fromMap(d.id, d.data())).toList();
    }
    final list = await LocalStore.readList('notes:$childId');
    return list.map((m) => NoteEntry.fromMap(m['id'] ?? '', m)).toList();
  }
}
