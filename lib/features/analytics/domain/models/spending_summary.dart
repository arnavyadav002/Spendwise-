import 'package:equatable/equatable.dart';

import '../../../../core/utils/money.dart';

class SpendingSummary extends Equatable {
  final Money totalSpent;
  final Map<String, Money> categoryBreakdown;

  const SpendingSummary({
    required this.totalSpent,
    required this.categoryBreakdown,
  });

  @override
  List<Object?> get props => [totalSpent, categoryBreakdown];
}
