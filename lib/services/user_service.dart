import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String uid,
    required String email,
    required String phone,
    required String name,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'phone': phone,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
