import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exercise_6_sqlite_persistence/main.dart';
import 'package:exercise_6_sqlite_persistence/database_helper.dart';

class FakeAccountStore implements AccountStore {
  final List<Map<String, dynamic>> accounts = [];
  int nextId = 1;

  @override
  Future<int> insertAccount(Map<String, dynamic> account) async {
    accounts.add({'id': nextId++, ...account});
    return nextId - 1;
  }

  @override
  Future<List<Map<String, dynamic>>> getAccounts() async {
    return accounts.reversed.toList();
  }

  @override
  Future<double> getTotalBalance() async {
    return accounts.fold<double>(
      0,
      (sum, account) => sum + (account['balance'] as num).toDouble(),
    );
  }
}

void main() {
  testWidgets('Bank Account Manager displays correctly', (
    WidgetTester tester,
  ) async {
    final store = FakeAccountStore();

    await tester.pumpWidget(BankAccountApp(store: store));
    await tester.pumpAndSettle();

    expect(find.text('Bank Account Manager'), findsOneWidget);
    expect(find.text('Simple Bank Account Manager'), findsOneWidget);

    // Verify both input fields are displayed.
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify the Save Account button.
    expect(find.byType(ElevatedButton), findsOneWidget);

    expect(find.text('Account Details'), findsOneWidget);
    expect(find.text('Total Money in Bank'), findsOneWidget);
    expect(find.text('No accounts added yet.'), findsOneWidget);
  });

  testWidgets('Account can be saved and total is calculated', (
    WidgetTester tester,
  ) async {
    final store = FakeAccountStore();

    await tester.pumpWidget(BankAccountApp(store: store));
    await tester.pumpAndSettle();

    // First field: Account Holder Name.
    await tester.enterText(find.byType(TextField).at(0), 'John');

    // Second field: Initial Balance.
    await tester.enterText(find.byType(TextField).at(1), '5000');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('John'), findsOneWidget);
    expect(find.text('Balance: \u20B95000.00'), findsOneWidget);
    expect(find.text('\u20B95000.00'), findsOneWidget);
    expect(find.text('Account saved successfully!'), findsOneWidget);

    expect(store.accounts.length, 1);
  });

  testWidgets('Zero balance displays Low Balance warning', (
    WidgetTester tester,
  ) async {
    final store = FakeAccountStore();

    await store.insertAccount({'accountHolder': 'Joel', 'balance': 0.0});

    await tester.pumpWidget(BankAccountApp(store: store));
    await tester.pumpAndSettle();

    expect(find.text('Joel'), findsOneWidget);
    expect(find.text('Low Balance!'), findsOneWidget);
  });

  testWidgets('Invalid input is rejected', (WidgetTester tester) async {
    final store = FakeAccountStore();

    await tester.pumpWidget(BankAccountApp(store: store));
    await tester.pumpAndSettle();

    // Tap Save Account without entering any values.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(
      find.text('Enter a valid account holder name and balance.'),
      findsOneWidget,
    );

    expect(store.accounts, isEmpty);
  });
}
