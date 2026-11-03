import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_8_library_book_search/screens/book_search_screen.dart';

void main() {
  testWidgets('Library search screen displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BookSearchScreen(),
      ),
    );

    expect(find.text('Library Book Search'), findsOneWidget);
    expect(find.text('Library Book Search System'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
  });
}