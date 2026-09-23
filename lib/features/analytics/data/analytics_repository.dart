import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/spending_summary.dart';
import '../../../core/utils/money.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

class AnalyticsRepository {
  Future<SpendingSummary> getMonthlySummary(int month, int year) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const SpendingSummary(
      totalSpent: Money(1500000),
      categoryBreakdown: {'Food': Money(500000), 'Transport': Money(200000)},
    );
  }
}
