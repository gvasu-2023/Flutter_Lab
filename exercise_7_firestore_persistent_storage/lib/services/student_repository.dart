import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student.dart';

abstract class StudentRepository {
  Stream<List<Student>> watchStudents();

  Future<bool> registerNumberExists(String registerNumber);

  Future<void> addStudent(Student student);
}

class FirestoreStudentRepository implements StudentRepository {
  final CollectionReference<Map<String, dynamic>> _students = FirebaseFirestore
      .instance
      .collection('students');

  @override
  Stream<List<Student>> watchStudents() {
    return _students.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((document) {
        return Student.fromMap(document.data());
      }).toList();
    });
  }

  @override
  Future<bool> registerNumberExists(String registerNumber) async {
    final result = await _students
        .where('registerNumber', isEqualTo: registerNumber.trim().toUpperCase())
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  @override
  Future<void> addStudent(Student student) async {
    await _students.add({
      'name': student.name.trim(),
      'registerNumber': student.registerNumber.trim().toUpperCase(),
      'department': student.department.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
