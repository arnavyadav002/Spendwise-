import 'package:equatable/equatable.dart';

import '../../../../core/utils/money.dart';

class SpendingSummary extends Equatable {
  final Money totalSpent;
  final Map<String, Money> categoryBreakdown;

  const SpendingSummary({
    required this.totalSpent,
    required this.categoryBreakdown,
  });

  factory SpendingSummary.fromJson(Map<String, dynamic> json) {
    final breakdown = <String, Money>{};
    final rawBreakdown =
        json['categoryBreakdown'] as Map<String, dynamic>? ?? {};
    rawBreakdown.forEach((key, value) {
      breakdown[key] = Money(value as int? ?? 0);
    });

    return SpendingSummary(
      totalSpent: Money(json['totalSpent'] as int? ?? 0),
      categoryBreakdown: breakdown,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalSpent': totalSpent.paise,
    'categoryBreakdown': categoryBreakdown.map((k, v) => MapEntry(k, v.paise)),
  };

  @override
  List<Object?> get props => [totalSpent, categoryBreakdown];
}
