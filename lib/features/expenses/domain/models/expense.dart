import 'package:equatable/equatable.dart';

import 'expense_category.dart';
import '../../../../core/utils/money.dart';

class Expense extends Equatable {
  final String id;
  final Money amount;
  final String description;
  final DateTime date;
  final ExpenseCategory category;

  const Expense({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      amount: Money(json['amount'] as int),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      category: ExpenseCategory.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount.paise,
    'description': description,
    'date': date.toIso8601String(),
    'category': category.toJson(),
  };

  Expense copyWith({
    String? id,
    Money? amount,
    String? description,
    DateTime? date,
    ExpenseCategory? category,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id, amount, description, date, category];
}
