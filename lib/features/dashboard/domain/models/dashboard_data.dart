import 'package:equatable/equatable.dart';

import '../../../expenses/domain/models/expense.dart';
import '../../../expenses/domain/models/expense_category.dart';
import '../../../../core/utils/money.dart';

class DashboardData extends Equatable {
  final Money totalBalance;
  final Money monthlySpending;
  final List<Expense> recentExpenses;
  final Map<ExpenseCategory, double> categoryPercentages;

  const DashboardData({
    required this.totalBalance,
    required this.monthlySpending,
    required this.recentExpenses,
    required this.categoryPercentages,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final recentList = (json['recentExpenses'] as List<dynamic>? ?? [])
        .map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList();

    // Map categories
    final defaultCategories = {
      'c1': const ExpenseCategory(id: 'c1', name: 'Food & Dining', icon: '🍔'),
      'c2': const ExpenseCategory(id: 'c2', name: 'Transport', icon: '🚗'),
      'c3': const ExpenseCategory(id: 'c3', name: 'Entertainment', icon: '🎬'),
      'c4': const ExpenseCategory(id: 'c4', name: 'Shopping', icon: '🛍️'),
      'c5': const ExpenseCategory(
        id: 'c5',
        name: 'Bills & Utilities',
        icon: '💡',
      ),
    };

    final rawPercentages =
        json['categoryPercentages'] as Map<String, dynamic>? ?? {};
    final categoryPercentages = <ExpenseCategory, double>{};
    rawPercentages.forEach((key, value) {
      final category =
          defaultCategories[key] ??
          ExpenseCategory(id: key, name: key, icon: '🏷️');
      categoryPercentages[category] = (value as num).toDouble();
    });

    return DashboardData(
      totalBalance: Money(json['totalBalance'] as int? ?? 0),
      monthlySpending: Money(json['monthlySpending'] as int? ?? 0),
      recentExpenses: recentList,
      categoryPercentages: categoryPercentages,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalBalance': totalBalance.paise,
    'monthlySpending': monthlySpending.paise,
    'recentExpenses': recentExpenses.map((e) => e.toJson()).toList(),
    'categoryPercentages': categoryPercentages.map((k, v) => MapEntry(k.id, v)),
  };

  @override
  List<Object?> get props => [
    totalBalance,
    monthlySpending,
    recentExpenses,
    categoryPercentages,
  ];
}
