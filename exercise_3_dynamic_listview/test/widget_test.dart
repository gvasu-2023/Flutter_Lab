import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_3_dynamic_listview/main.dart';

void main() {
  testWidgets('Student list displays initial records', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DynamicListViewApp());

    expect(find.text('Student Record Manager'), findsOneWidget);
    expect(find.text('Arun Kumar'), findsOneWidget);
    expect(find.text('Priya Sharma'), findsOneWidget);
    expect(find.text('Rahul'), findsOneWidget);
    expect(find.text('3 Students'), findsOneWidget);
  });

  testWidgets('New student is added dynamically', (WidgetTester tester) async {
    await tester.pumpWidget(const DynamicListViewApp());

    await tester.enterText(find.byKey(const ValueKey('studentName')), 'Meera');

    await tester.enterText(
      find.byKey(const ValueKey('registerNumber')),
      'STU004',
    );

    await tester.enterText(
      find.byKey(const ValueKey('department')),
      'Artificial Intelligence',
    );

    final addButton = find.text('Add Student');

    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.text('Meera'), findsOneWidget);
    expect(find.text('4 Students'), findsOneWidget);
    expect(find.text('Student added successfully!'), findsOneWidget);
  });

  testWidgets('Student can be deleted dynamically', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DynamicListViewApp());

    final deleteButton = find.byKey(const ValueKey('delete-STU001'));

    // Scroll until the delete button becomes visible.
    await tester.ensureVisible(deleteButton);
    await tester.pumpAndSettle();

    // Delete the student.
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Arun Kumar'), findsNothing);
    expect(find.text('2 Students'), findsOneWidget);
    expect(find.text('Arun Kumar removed successfully.'), findsOneWidget);
  });

  testWidgets('Empty fields display validation errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DynamicListViewApp());

    final addButton = find.text('Add Student');

    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsNWidgets(3));
    expect(find.text('3 Students'), findsOneWidget);
  });
}
