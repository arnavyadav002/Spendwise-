import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    return const [
      CategoryModel(id: 'c1', name: 'Food'),
      CategoryModel(id: 'c2', name: 'Transport'),
    ];
  }
}
