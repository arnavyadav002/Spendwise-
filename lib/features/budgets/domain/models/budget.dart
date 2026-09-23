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

  double get progress => (spent.asRupees / limit.asRupees).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [id, categoryId, limit, spent];
}
