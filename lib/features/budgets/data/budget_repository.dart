import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/budget.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/error_mapper.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.read(apiClientProvider));
});

class BudgetRepository {
  final Dio _dio;

  BudgetRepository(this._dio);

  Future<List<Budget>> getBudgets() async {
    try {
      final response = await _dio.get('/budgets');
      final list = (response.data as List<dynamic>)
          .cast<Map<String, dynamic>>();
      return list.map(Budget.fromJson).toList();
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }

  Future<Budget> createBudget(Budget budget) async {
    try {
      final response = await _dio.post('/budgets', data: budget.toJson());
      return Budget.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }
}
