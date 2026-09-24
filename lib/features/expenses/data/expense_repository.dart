import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/expense.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/error_mapper.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref.read(apiClientProvider));
});

class ExpenseRepository {
  final Dio _dio;

  ExpenseRepository(this._dio);

  Future<List<Expense>> getExpenses() async {
    try {
      final response = await _dio.get('/expenses');
      final list = (response.data as List<dynamic>)
          .cast<Map<String, dynamic>>();
      return list.map(Expense.fromJson).toList();
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }

  Future<Expense> addExpense(Expense expense) async {
    try {
      final response = await _dio.post('/expenses', data: expense.toJson());
      return Expense.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }

  Future<Expense> updateExpense(Expense expense) async {
    try {
      final response = await _dio.put(
        '/expenses/${expense.id}',
        data: expense.toJson(),
      );
      return Expense.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _dio.delete('/expenses/$id');
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }
}
