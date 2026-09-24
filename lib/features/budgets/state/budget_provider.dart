import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/budget_repository.dart';
import '../domain/models/budget.dart';
import '../../dashboard/state/dashboard_provider.dart';

class BudgetsNotifier extends AsyncNotifier<List<Budget>> {
  @override
  Future<List<Budget>> build() async {
    final repository = ref.read(budgetRepositoryProvider);
    return repository.getBudgets();
  }

  Future<void> loadBudgets() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(budgetRepositoryProvider);
      final budgets = await repository.getBudgets();
      state = AsyncValue.data(budgets);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createBudget(Budget budget) async {
    try {
      final repository = ref.read(budgetRepositoryProvider);
      final created = await repository.createBudget(budget);
      final current = state.value ?? [];
      final updated = [
        ...current.where((b) => b.categoryId != created.categoryId),
        created,
      ];
      state = AsyncValue.data(updated);
      ref.invalidate(dashboardProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final budgetsProvider = AsyncNotifierProvider<BudgetsNotifier, List<Budget>>(
  () {
    return BudgetsNotifier();
  },
);

// For backward compatibility
final budgetProvider = budgetsProvider;
