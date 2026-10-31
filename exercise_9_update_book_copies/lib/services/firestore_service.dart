import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _books =
      FirebaseFirestore.instance.collection('books');

  Future<Map<String, dynamic>?> searchBook(String title) async {
    final query = await _books
        .where('title', isEqualTo: title.trim())
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    final document = query.docs.first;

    return {
      'documentId': document.id,
      ...document.data(),
    };
  }

  Future<void> updateCopies(String documentId, int copies) async {
    await _books.doc(documentId).update({
      'copies': copies,
    });
  }
}