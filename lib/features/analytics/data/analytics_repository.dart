import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/spending_summary.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/error_mapper.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.read(apiClientProvider));
});

class AnalyticsRepository {
  final Dio _dio;

  AnalyticsRepository(this._dio);

  Future<SpendingSummary> getMonthlySummary(int month, int year) async {
    try {
      final response = await _dio.get(
        '/analytics',
        queryParameters: {'month': month, 'year': year},
      );
      return SpendingSummary.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }
}
