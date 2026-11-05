import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exercise_7_firestore_persistent_storage/models/student.dart';
import 'package:exercise_7_firestore_persistent_storage/screens/student_screen.dart';
import 'package:exercise_7_firestore_persistent_storage/services/student_repository.dart';

class FakeStudentRepository implements StudentRepository {
  final List<Student> students;

  final StreamController<List<Student>> _controller =
      StreamController<List<Student>>.broadcast();

  FakeStudentRepository({List<Student>? initialStudents})
    : students = List<Student>.from(initialStudents ?? []);

  @override
  Stream<List<Student>> watchStudents() async* {
    yield List<Student>.unmodifiable(students);

    yield* _controller.stream;
  }

  @override
  Future<bool> registerNumberExists(String registerNumber) async {
    return students.any(
      (student) =>
          student.registerNumber.toUpperCase() == registerNumber.toUpperCase(),
    );
  }

  @override
  Future<void> addStudent(Student student) async {
    students.add(student);

    _controller.add(List<Student>.unmodifiable(students));
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

void main() {
  testWidgets('Student screen displays correctly', (WidgetTester tester) async {
    final repository = FakeStudentRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      MaterialApp(home: StudentScreen(repository: repository)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Firestore Student Records'), findsOneWidget);
    expect(find.text('Student Record Management'), findsOneWidget);
    expect(find.text('Enter Student Details'), findsOneWidget);
    expect(find.text('Stored Student Records'), findsOneWidget);
    expect(find.text('No student records found.'), findsOneWidget);
  });

  testWidgets('Student can be added to the records', (
    WidgetTester tester,
  ) async {
    final repository = FakeStudentRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      MaterialApp(home: StudentScreen(repository: repository)),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('studentName')), 'Meera');

    await tester.enterText(
      find.byKey(const ValueKey('registerNumber')),
      'STU004',
    );

    await tester.enterText(
      find.byKey(const ValueKey('department')),
      'Artificial Intelligence',
    );

    final saveButton = find.byKey(const ValueKey('saveStudentButton'));

    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Meera'), findsOneWidget);
    expect(find.textContaining('STU004'), findsOneWidget);
    expect(find.text('1 Students'), findsOneWidget);

    expect(
      find.text('Student saved to Firestore successfully!'),
      findsOneWidget,
    );
  });

  testWidgets('Duplicate register number is rejected', (
    WidgetTester tester,
  ) async {
    final repository = FakeStudentRepository(
      initialStudents: const [
        Student(
          name: 'Arun Kumar',
          registerNumber: 'STU001',
          department: 'Computer Science',
        ),
      ],
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      MaterialApp(home: StudentScreen(repository: repository)),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('studentName')),
      'Another Arun',
    );

    await tester.enterText(
      find.byKey(const ValueKey('registerNumber')),
      'stu001',
    );

    await tester.enterText(
      find.byKey(const ValueKey('department')),
      'Information Technology',
    );

    final saveButton = find.byKey(const ValueKey('saveStudentButton'));

    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Register number already exists.'), findsOneWidget);

    expect(repository.students.length, 1);
  });

  testWidgets('Empty fields display validation errors', (
    WidgetTester tester,
  ) async {
    final repository = FakeStudentRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      MaterialApp(home: StudentScreen(repository: repository)),
    );

    await tester.pumpAndSettle();

    final saveButton = find.byKey(const ValueKey('saveStudentButton'));

    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsNWidgets(3));

    expect(repository.students, isEmpty);
  });
}
