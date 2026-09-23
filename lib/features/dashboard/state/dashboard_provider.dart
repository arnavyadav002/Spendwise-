import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_repository.dart';
import '../domain/models/dashboard_data.dart';

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final repository = ref.read(dashboardRepositoryProvider);
  return repository.getDashboardData();
});
