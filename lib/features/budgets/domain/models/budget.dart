import 'package:equatable/equatable.dart';

import '../../../../core/utils/money.dart';

class Budget extends Equatable {
  final String id;
  final String categoryId;
  final Money limit;
  final Money spent;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.spent,
  });

  double get progress {
    if (limit.paise <= 0) return 0.0;
    return (spent.paise / limit.paise).clamp(0.0, 1.0);
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      limit: Money(json['limit'] as int? ?? 0),
      spent: Money(json['spent'] as int? ?? 0),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'limit': limit.paise,
    'spent': spent.paise,
  };

  @override
  List<Object?> get props => [id, categoryId, limit, spent];
}
