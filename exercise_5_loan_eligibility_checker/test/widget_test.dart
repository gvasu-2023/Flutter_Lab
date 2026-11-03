
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_5_loan_eligibility_checker/main.dart';

void main() {
  testWidgets('Eligible customer sees approval result',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LoanEligibilityApp());

    await tester.enterText(
      find.byType(TextFormField).at(0), 'John',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1), '30',
    );
    await tester.enterText(
      find.byType(TextFormField).at(2), '50000',
    );
    await tester.enterText(
      find.byType(TextFormField).at(3), '5000',
    );
    await tester.enterText(
      find.byType(TextFormField).at(4), '200000',
    );

    await tester.ensureVisible(
      find.text('Check Loan Eligibility'),
    );
    await tester.tap(find.text('Check Loan Eligibility'));
    await tester.pumpAndSettle();

    expect(find.text('LOAN ELIGIBLE'), findsOneWidget);
    expect(find.text('John'), findsOneWidget);
    expect(find.text('Approved Loan Amount'), findsOneWidget);
    expect(find.text('Debt-to-Income Ratio'), findsOneWidget);
  });

  testWidgets('Ineligible customer sees rejection reasons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LoanEligibilityApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Sam');
    await tester.enterText(find.byType(TextFormField).at(1), '19');
    await tester.enterText(find.byType(TextFormField).at(2), '30000');
    await tester.enterText(find.byType(TextFormField).at(3), '20000');
    await tester.enterText(find.byType(TextFormField).at(4), '200000');

    await tester.ensureVisible(find.text('Check Loan Eligibility'));
    await tester.tap(find.text('Check Loan Eligibility'));
    await tester.pumpAndSettle();

    expect(find.text('NOT ELIGIBLE'), findsOneWidget);
    expect(
      find.text('Age must be between 21 and 60 years.'),
      findsOneWidget,
    );
  });

  testWidgets('Empty form displays validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LoanEligibilityApp());

    await tester.ensureVisible(find.text('Check Loan Eligibility'));
    await tester.tap(find.text('Check Loan Eligibility'));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsNWidgets(5));
    expect(find.text('Customer Details Form'), findsOneWidget);
  });

  testWidgets('Reset returns to customer input screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LoanEligibilityApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), '30');
    await tester.enterText(find.byType(TextFormField).at(2), '50000');
    await tester.enterText(find.byType(TextFormField).at(3), '5000');
    await tester.enterText(find.byType(TextFormField).at(4), '200000');

    await tester.ensureVisible(find.text('Check Loan Eligibility'));
    await tester.tap(find.text('Check Loan Eligibility'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.text('Reset / Check Another Customer'),
    );
    await tester.tap(find.text('Reset / Check Another Customer'));
    await tester.pumpAndSettle();

    expect(find.text('Customer Details Form'), findsOneWidget);
    expect(find.text('John'), findsNothing);
  });
}
