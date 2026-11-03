import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Firebase is accessed only when a search is performed.
  CollectionReference<Map<String, dynamic>> get _books =>
      FirebaseFirestore.instance.collection('books');

  Future<Map<String, dynamic>?> searchBook(String title) async {
    final result = await _books
        .where('title', isEqualTo: title.trim())
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return null;
    }

    return result.docs.first.data();
  }
}