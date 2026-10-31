import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_9_update_book_copies/main.dart';

void main() {
  testWidgets('Book update application loads', (WidgetTester tester) async {
    await tester.pumpWidget(const BookUpdateApp());

    await tester.pump();

    expect(find.text('Update Book Copies'), findsOneWidget);
    expect(find.text('Library Book Management'), findsOneWidget);
    expect(find.text('Search Book'), findsOneWidget);
  });
}