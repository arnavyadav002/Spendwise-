import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/money.dart';
import '../../expenses/state/expense_provider.dart';
import '../domain/models/spending_summary.dart';

final analyticsProvider = FutureProvider<SpendingSummary>((ref) async {
  final expenses = await ref.watch(expensesProvider.future);
  final now = DateTime.now();

  final monthlyExpenses = expenses
      .where(
        (expense) =>
            expense.date.year == now.year && expense.date.month == now.month,
      )
      .toList();

  final categoryBreakdown = <String, Money>{};
  var totalSpent = 0;

  for (final expense in monthlyExpenses) {
    final categoryName = expense.category.name;
    final current = categoryBreakdown[categoryName]?.paise ?? 0;
    categoryBreakdown[categoryName] = Money(current + expense.amount.paise);
    totalSpent += expense.amount.paise;
  }

  return SpendingSummary(
    totalSpent: Money(totalSpent),
    categoryBreakdown: categoryBreakdown,
  );
});
