import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    try {
      final repository = ref.read(expenseRepositoryProvider);
      final newExpense = await repository.addExpense(expense);
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, newExpense]);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateExpense(Expense expense) async {
    final oldState = state;
    if (state.hasValue) {
      final currentExpenses = state.value!;
      final updatedList = currentExpenses
          .map((e) => e.id == expense.id ? expense : e)
          .toList();
      state = AsyncValue.data(updatedList);
    }

    try {
      final repository = ref.read(expenseRepositoryProvider);
      await repository.updateExpense(expense);
    } catch (e) {
      state = oldState;
    }
  }
}

final expensesProvider = AsyncNotifierProvider<ExpensesNotifier, List<Expense>>(
  () {
    return ExpensesNotifier();
  },
);
