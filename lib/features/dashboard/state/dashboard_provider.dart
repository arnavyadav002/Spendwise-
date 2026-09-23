import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../expenses/domain/models/expense_category.dart';
import '../../expenses/state/expense_provider.dart';
import '../../../core/utils/money.dart';
import '../domain/models/dashboard_data.dart';

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final expenses = await ref.watch(expensesProvider.future);
  final now = DateTime.now();

  final monthlyExpenses =
      expenses
          .where(
            (expense) =>
                expense.date.year == now.year &&
                expense.date.month == now.month,
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  final categoryTotals = <ExpenseCategory, int>{};
  var totalSpent = 0;

  for (final expense in monthlyExpenses) {
    categoryTotals[expense.category] =
        (categoryTotals[expense.category] ?? 0) + expense.amount.paise;
    totalSpent += expense.amount.paise;
  }

  final categoryPercentages = <ExpenseCategory, double>{};
  if (totalSpent > 0) {
    categoryTotals.forEach((category, amount) {
      categoryPercentages[category] = amount / totalSpent;
    });
  }

  final recentExpenses = expenses.toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  return DashboardData(
    totalBalance: const Money(0),
    monthlySpending: Money(totalSpent),
    recentExpenses: recentExpenses.take(6).toList(),
    categoryPercentages: categoryPercentages,
  );
});
