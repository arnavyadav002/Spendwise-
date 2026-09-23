import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/budget.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository();
});

class BudgetRepository {
  Future<List<Budget>> getBudgets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}
