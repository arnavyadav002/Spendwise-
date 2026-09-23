import 'package:flutter/material.dart';

import '../domain/models/expense.dart';
import 'expense_card.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseCard(expense: expense);
      },
    );
  }
}
