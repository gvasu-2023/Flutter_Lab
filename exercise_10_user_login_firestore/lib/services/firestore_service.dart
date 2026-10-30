
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      // Step 1: Fetch user using email.
      final result = await _firestore
          .collection('users')
          .where('email', isEqualTo: normalizedEmail)
          .limit(1)
          .get();

      debugPrint('Matching email documents: ${result.docs.length}');

      // Step 2: Check whether the user exists.
      if (result.docs.isEmpty) {
        debugPrint('No user found for entered email.');
        return null;
      }

      // Step 3: Retrieve user details.
      final user = result.docs.first.data();

      final storedEmail =
          user['email']?.toString().trim().toLowerCase();

      final storedPassword =
          user['password']?.toString();

      // Step 4: Manually verify credentials.
      if (storedEmail == normalizedEmail &&
          storedPassword == password) {
        debugPrint('User credentials matched.');
        return user;
      }

      debugPrint('Password verification failed.');
      return null;
    } catch (e) {
      debugPrint('Firestore authentication error: $e');
      rethrow;
    }
  }
}
