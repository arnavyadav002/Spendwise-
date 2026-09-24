import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/app/app.dart';

import '../helpers/fake_api.dart';

void main() {
  setUp(() {
    FakeApi.reset();
  });

  testWidgets(
    'Full flow: Login -> Dashboard -> History -> Add expense -> View in Dashboard',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const ProviderScope(child: SpendWiseApp()));
      await tester.pumpAndSettle();

      // 1. Verify on Login screen
      expect(find.text('SpendWise'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      // 2. Sign In
      await tester.tap(find.text('Sign In'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // 3. Verify on Dashboard
      expect(find.text('Spent this month'), findsOneWidget);
      expect(find.text('Recent Transactions'), findsOneWidget);

      // 4. Tap "See all" button
      final seeAllFinder = find.text('See all');
      expect(seeAllFinder, findsOneWidget);
      await tester.tap(seeAllFinder);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // 5. Verify on All Transactions screen
      expect(find.text('All Transactions'), findsOneWidget);

      // 6. Go back to Dashboard
      final backButton = find.byType(BackButton);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // 7. Tap "Add Expense" Quick Action on Dashboard
      final addExpenseBtn = find.text('Add Expense').first;
      await tester.tap(addExpenseBtn);
      await tester.pumpAndSettle();

      // 8. Verify on Add Expense screen
      expect(find.text('Add Expense'), findsOneWidget);

      // 9. Enter amount and description
      await tester.enterText(find.byType(TextFormField).first, '350');
      await tester.enterText(
        find.byType(TextFormField).last,
        'Blue Tokai Latte',
      );

      // 10. Tap Save Expense
      final saveButton = find.text('Save Expense');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // 11. Verify returned to Dashboard and transaction is visible
      expect(find.text('Spent this month'), findsOneWidget);
      expect(find.text('Blue Tokai Latte'), findsOneWidget);
    },
  );
}
