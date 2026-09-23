import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/budget_repository.dart';
import '../domain/models/budget.dart';

final budgetProvider = FutureProvider<List<Budget>>((ref) async {
  return ref.read(budgetRepositoryProvider).getBudgets();
});
