
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_1_student_application/main.dart';

void main() {
  testWidgets('Student Application displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Student Application'), findsOneWidget);
    expect(find.text('Welcome User!!'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
    expect(find.byIcon(Icons.call), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Search field accepts text', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'Flutter');

    expect(find.text('Flutter'), findsOneWidget);
  });

  testWidgets('Submit button is available and tappable',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final submitButton = find.widgetWithText(ElevatedButton, 'Submit');

    expect(submitButton, findsOneWidget);

    await tester.tap(submitButton);
    await tester.pump();

    expect(submitButton, findsOneWidget);
  });

  testWidgets('Application uses a scrollable layout',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Padding), findsWidgets);
    expect(find.byType(Column), findsOneWidget);
  });
}
