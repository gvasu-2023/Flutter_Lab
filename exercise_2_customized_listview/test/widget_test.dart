
import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_2_customized_listview/main.dart';

void main() {
  testWidgets('Custom ListView screen displays correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CustomListViewApp());

    expect(find.text('Custom List View'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Orange'), findsOneWidget);
    expect(find.text('Mango'), findsOneWidget);
    expect(find.text('Pomegranate'), findsOneWidget);
  });

  testWidgets('Product prices are displayed correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CustomListViewApp());

    expect(find.text('₹180.00'), findsOneWidget);
    expect(find.text('₹100.00'), findsOneWidget);
    expect(find.text('₹70.00'), findsOneWidget);
    expect(find.text('₹250.00'), findsOneWidget);
  });

  testWidgets('Each product has a Buy Now button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CustomListViewApp());

    expect(find.text('Buy Now'), findsNWidgets(4));
  });

  testWidgets('Buy Now displays product selection message',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CustomListViewApp());

    await tester.tap(find.text('Buy Now').first);
    await tester.pump();

    expect(find.text('Apple selected!'), findsOneWidget);
  });
}
