import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../analytics/state/analytics_provider.dart';
import '../../dashboard/state/dashboard_provider.dart';
import '../data/expense_repository.dart';
import '../domain/models/expense.dart';

class ExpensesNotifier extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() async {
    final repository = ref.read(expenseRepositoryProvider);
    return repository.getExpenses();
  }

  Future<void> loadExpenses() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(expenseRepositoryProvider);
      final expenses = await repository.getExpenses();
      state = AsyncValue.data(expenses);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addExpense(Expense expense) async {
    final previous = state.value ?? const <Expense>[];
    final optimisticList = <Expense>[expense, ...previous];
    state = AsyncValue.data(optimisticList);

    try {
      final repository = ref.read(expenseRepositoryProvider);
      final savedExpense = await repository.addExpense(expense);
      final updatedList = <Expense>[savedExpense, ...previous];
      state = AsyncValue.data(updatedList);
      ref.invalidate(dashboardProvider);
      ref.invalidate(analyticsProvider);
    } catch (e, stack) {
      state = AsyncValue.data(previous);
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    final previous = state.value ?? const <Expense>[];
    final updatedList = previous
        .map((item) => item.id == expense.id ? expense : item)
        .toList();
    state = AsyncValue.data(updatedList);

    try {
      final repository = ref.read(expenseRepositoryProvider);
      await repository.updateExpense(expense);
      ref.invalidate(dashboardProvider);
      ref.invalidate(analyticsProvider);
    } catch (e, stack) {
      state = AsyncValue.data(previous);
      state = AsyncValue.error(e, stack);
    }
  }
}

final expensesProvider = AsyncNotifierProvider<ExpensesNotifier, List<Expense>>(
  () => ExpensesNotifier(),
);
