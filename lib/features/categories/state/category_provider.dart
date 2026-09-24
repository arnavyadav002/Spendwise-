import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/category_repository.dart';
import '../../expenses/domain/models/expense_category.dart';

final categoryProvider = FutureProvider<List<ExpenseCategory>>((ref) async {
  return ref.read(categoryRepositoryProvider).getCategories();
});
