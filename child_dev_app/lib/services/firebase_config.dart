import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static bool isConfigured(FirebaseOptions options) {
    final fields = <String?>[
      options.apiKey,
      options.appId,
      options.messagingSenderId,
      options.projectId,
      options.storageBucket,
    ];
    return !fields.any((v) => v == null || v.isEmpty || v == 'PLACEHOLDER');
  }
}
