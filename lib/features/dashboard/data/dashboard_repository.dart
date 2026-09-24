import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/dashboard_data.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/error_mapper.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.read(apiClientProvider));
});

class DashboardRepository {
  final Dio _dio;

  DashboardRepository(this._dio);

  Future<DashboardData> getDashboardData() async {
    try {
      final response = await _dio.get('/dashboard');
      return DashboardData.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }
}
