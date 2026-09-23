import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/features/expenses/presentation/expense_details_screen.dart';

void main() {
  testWidgets(
    'ExpenseDetailsScreen renders a safe fallback when no expense id is passed',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ExpenseDetailsScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Unable to load expense'), findsOneWidget);
    },
  );
}
