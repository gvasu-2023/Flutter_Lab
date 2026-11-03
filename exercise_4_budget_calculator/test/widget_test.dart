
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_4_budget_calculator/main.dart';

void main() {
  testWidgets(
    'Budget Calculator screen displays all input fields',
    (WidgetTester tester) async {
      await tester.pumpWidget(const BudgetCalculatorApp());

      expect(find.text('Monthly Budget Planner'), findsOneWidget);
      expect(find.text('Monthly Income'), findsOneWidget);
      expect(find.text('Rent / EMI'), findsOneWidget);
      expect(find.text('Food Expenses'), findsOneWidget);
      expect(find.text('Transport Expenses'), findsOneWidget);
      expect(find.text('Other Expenses'), findsOneWidget);
      expect(find.text('Calculate Balance'), findsOneWidget);
    },
  );

  testWidgets(
    'Positive balance displays success message',
    (WidgetTester tester) async {
      await tester.pumpWidget(const BudgetCalculatorApp());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), '50000');
      await tester.enterText(fields.at(1), '10000');
      await tester.enterText(fields.at(2), '8000');
      await tester.enterText(fields.at(3), '3000');
      await tester.enterText(fields.at(4), '2000');

      await tester.ensureVisible(find.text('Calculate Balance'));
      await tester.tap(find.text('Calculate Balance'));
      await tester.pumpAndSettle();

      expect(find.text('Remaining Balance'), findsOneWidget);
      expect(find.text('₹27000.00'), findsOneWidget);
      expect(
        find.text('Good job! You have money remaining.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Negative balance displays overspending warning',
    (WidgetTester tester) async {
      await tester.pumpWidget(const BudgetCalculatorApp());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), '20000');
      await tester.enterText(fields.at(1), '10000');
      await tester.enterText(fields.at(2), '8000');
      await tester.enterText(fields.at(3), '5000');
      await tester.enterText(fields.at(4), '3000');

      await tester.ensureVisible(find.text('Calculate Balance'));
      await tester.tap(find.text('Calculate Balance'));
      await tester.pumpAndSettle();

      expect(find.text('₹-6000.00'), findsOneWidget);
      expect(find.text('You are overspending!'), findsOneWidget);
    },
  );

  testWidgets(
    'Empty form displays validation errors',
    (WidgetTester tester) async {
      await tester.pumpWidget(const BudgetCalculatorApp());

      await tester.ensureVisible(find.text('Calculate Balance'));
      await tester.tap(find.text('Calculate Balance'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please enter your monthly income'),
        findsOneWidget,
      );
      expect(
        find.text('Please enter this expense'),
        findsNWidgets(4),
      );
      expect(find.text('Remaining Balance'), findsNothing);
    },
  );

  testWidgets(
    'Reset clears all fields and calculated result',
    (WidgetTester tester) async {
      await tester.pumpWidget(const BudgetCalculatorApp());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), '50000');
      await tester.enterText(fields.at(1), '10000');
      await tester.enterText(fields.at(2), '8000');
      await tester.enterText(fields.at(3), '3000');
      await tester.enterText(fields.at(4), '2000');

      await tester.ensureVisible(find.text('Calculate Balance'));
      await tester.tap(find.text('Calculate Balance'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Reset'));
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Remaining Balance'), findsNothing);
      expect(find.text('₹27000.00'), findsNothing);

      expect(
        tester.widget<TextFormField>(fields.at(0)).controller!.text,
        isEmpty,
      );
      expect(
        tester.widget<TextFormField>(fields.at(1)).controller!.text,
        isEmpty,
      );
      expect(
        tester.widget<TextFormField>(fields.at(2)).controller!.text,
        isEmpty,
      );
      expect(
        tester.widget<TextFormField>(fields.at(3)).controller!.text,
        isEmpty,
      );
      expect(
        tester.widget<TextFormField>(fields.at(4)).controller!.text,
        isEmpty,
      );
    },
  );
}
