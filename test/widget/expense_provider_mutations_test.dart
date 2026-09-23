import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/core/utils/money.dart';
import 'package:spendwise/features/dashboard/state/dashboard_provider.dart';
import 'package:spendwise/features/expenses/domain/models/expense.dart';
import 'package:spendwise/features/expenses/domain/models/expense_category.dart';
import 'package:spendwise/features/expenses/state/expense_provider.dart';

void main() {
  test(
    'addExpense keeps the list in sync even before the first load completes',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(expensesProvider.notifier);
      final expense = Expense(
        id: 'test-1',
        amount: const Money(25000),
        description: 'Taxi fare',
        date: DateTime.now(),
        category: const ExpenseCategory(
          id: 'c2',
          name: 'Transport',
          icon: '🚗',
        ),
      );

      await notifier.addExpense(expense);

      expect(container.read(expensesProvider).value, isNotNull);
      expect(container.read(expensesProvider).value, contains(expense));
    },
  );

  test(
    'updateExpense rewrites the matching transaction in provider state',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(expensesProvider.notifier);
      final original = Expense(
        id: 'test-2',
        amount: const Money(5000),
        description: 'Groceries',
        date: DateTime.now(),
        category: const ExpenseCategory(
          id: 'c1',
          name: 'Food & Dining',
          icon: '🍔',
        ),
      );

      await notifier.addExpense(original);
      final updated = original.copyWith(
        description: 'Fresh groceries',
        amount: const Money(7500),
      );

      await notifier.updateExpense(updated);

      final list = container.read(expensesProvider).value ?? const <Expense>[];
      expect(list, contains(updated));
    },
  );

  test(
    'dashboard monthly total matches the live expenses for the current month',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(expensesProvider.notifier);
      final currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
      final currentExpense = Expense(
        id: 'test-dashboard-1',
        amount: const Money(120000),
        description: 'Monthly total check',
        date: currentMonth.add(const Duration(days: 3)),
        category: const ExpenseCategory(
          id: 'c3',
          name: 'Entertainment',
          icon: '🎬',
        ),
      );

      await notifier.addExpense(currentExpense);

      final expenses =
          container.read(expensesProvider).value ?? const <Expense>[];
      final expectedTotal = expenses
          .where(
            (expense) =>
                expense.date.year == currentMonth.year &&
                expense.date.month == currentMonth.month,
          )
          .fold<int>(0, (sum, expense) => sum + expense.amount.paise);

      final dashboard = await container.read(dashboardProvider.future);

      expect(dashboard.monthlySpending.paise, equals(expectedTotal));
    },
  );
}
