import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/category_repository.dart';
import '../domain/models/category.dart';

final categoryProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return ref.read(categoryRepositoryProvider).getCategories();
});
