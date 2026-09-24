import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../expenses/domain/models/expense_category.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/error_mapper.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.read(apiClientProvider));
});

class CategoryRepository {
  final Dio _dio;

  CategoryRepository(this._dio);

  Future<List<ExpenseCategory>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      final list = (response.data as List<dynamic>)
          .cast<Map<String, dynamic>>();
      return list.map(ExpenseCategory.fromJson).toList();
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }
}
