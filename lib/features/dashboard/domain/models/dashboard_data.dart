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

  @override
  List<Object?> get props => [
    totalBalance,
    monthlySpending,
    recentExpenses,
    categoryPercentages,
  ];
}
