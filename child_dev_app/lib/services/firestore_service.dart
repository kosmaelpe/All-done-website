import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  FirebaseFirestore get instance => _db;
}
