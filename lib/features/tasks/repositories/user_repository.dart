import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;

class UserRepository {
  UserRepository({cloud_firestore.FirebaseFirestore? firestore})
    : _firestore = firestore ?? cloud_firestore.FirebaseFirestore.instance;

  final cloud_firestore.FirebaseFirestore _firestore;

  cloud_firestore.DocumentReference<Map<String, dynamic>> userDocument(
    String userId,
  ) {
    return _firestore.collection('users').doc(userId);
  }

  Stream<cloud_firestore.DocumentSnapshot<Map<String, dynamic>>> watchUser(
    String userId,
  ) {
    return userDocument(userId).snapshots();
  }

  Future<void> ensureUserDocument({
    required String userId,
    required String name,
    required String email,
  }) async {
    await userDocument(userId).set(
      {
        'id': userId,
        'name': name,
        'email': email,
      },
      cloud_firestore.SetOptions(merge: true),
    );
  }

  Future<void> updateProfileAvatar({
    required String userId,
    required String avatarBase64,
  }) async {
    await userDocument(userId).set(
      {'avatarBase64': avatarBase64},
      cloud_firestore.SetOptions(merge: true),
    );
  }
}
