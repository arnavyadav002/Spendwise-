import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/analytics_repository.dart';
import '../domain/models/spending_summary.dart';

final analyticsProvider = FutureProvider<SpendingSummary>((ref) async {
  final repository = ref.read(analyticsRepositoryProvider);
  final now = DateTime.now();
  return repository.getMonthlySummary(now.month, now.year);
});
