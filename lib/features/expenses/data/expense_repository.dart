import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/expense.dart';
import '../domain/models/expense_category.dart';
import '../../../core/utils/money.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

class ExpenseRepository {
  final List<Expense> _mockExpenses;

  ExpenseRepository() : _mockExpenses = _generateMockExpenses();

  static List<Expense> _generateMockExpenses() {
    final categories = {
      'Food': const ExpenseCategory(
        id: 'c1',
        name: 'Food & Dining',
        icon: '🍔',
      ),
      'Transport': const ExpenseCategory(
        id: 'c2',
        name: 'Transport',
        icon: '🚗',
      ),
      'Entertainment': const ExpenseCategory(
        id: 'c3',
        name: 'Entertainment',
        icon: '🎬',
      ),
      'Shopping': const ExpenseCategory(
        id: 'c4',
        name: 'Shopping',
        icon: '🛍️',
      ),
      'Bills': const ExpenseCategory(
        id: 'c5',
        name: 'Bills & Utilities',
        icon: '💡',
      ),
    };

    final now = DateTime.now();
    return [
      Expense(
        id: '1',
        amount: const Money(35000),
        description: 'Starbucks Coffee',
        date: now.subtract(const Duration(hours: 2)),
        category: categories['Food']!,
      ),
      Expense(
        id: '2',
        amount: const Money(245000),
        description: 'Grocery at FreshMart',
        date: now.subtract(const Duration(hours: 5)),
        category: categories['Shopping']!,
      ),
      Expense(
        id: '3',
        amount: const Money(85000),
        description: 'Uber to Airport',
        date: now.subtract(const Duration(days: 1)),
        category: categories['Transport']!,
      ),
      Expense(
        id: '4',
        amount: const Money(64900),
        description: 'Netflix Subscription',
        date: now.subtract(const Duration(days: 1, hours: 4)),
        category: categories['Entertainment']!,
      ),
      Expense(
        id: '5',
        amount: const Money(180000),
        description: 'Electricity Bill',
        date: now.subtract(const Duration(days: 2)),
        category: categories['Bills']!,
      ),
      Expense(
        id: '6',
        amount: const Money(129900),
        description: 'Zara T-Shirt',
        date: now.subtract(const Duration(days: 2, hours: 2)),
        category: categories['Shopping']!,
      ),
      Expense(
        id: '7',
        amount: const Money(85000),
        description: 'Pizza Hut Delivery',
        date: now.subtract(const Duration(days: 3)),
        category: categories['Food']!,
      ),
      Expense(
        id: '8',
        amount: const Money(50000),
        description: 'Metro Recharge',
        date: now.subtract(const Duration(days: 3, hours: 5)),
        category: categories['Transport']!,
      ),
      Expense(
        id: '9',
        amount: const Money(90000),
        description: 'Cinema Tickets',
        date: now.subtract(const Duration(days: 4)),
        category: categories['Entertainment']!,
      ),
      Expense(
        id: '10',
        amount: const Money(40000),
        description: 'Water Bill',
        date: now.subtract(const Duration(days: 4, hours: 8)),
        category: categories['Bills']!,
      ),
      Expense(
        id: '11',
        amount: const Money(55000),
        description: 'Swiggy Dinner',
        date: now.subtract(const Duration(days: 5)),
        category: categories['Food']!,
      ),
      Expense(
        id: '12',
        amount: const Money(149900),
        description: 'Amazon Prime',
        date: now.subtract(const Duration(days: 6)),
        category: categories['Entertainment']!,
      ),
      Expense(
        id: '13',
        amount: const Money(200000),
        description: 'Petrol',
        date: now.subtract(const Duration(days: 6, hours: 1)),
        category: categories['Transport']!,
      ),
      Expense(
        id: '14',
        amount: const Money(450000),
        description: 'Headphones',
        date: now.subtract(const Duration(days: 7)),
        category: categories['Shopping']!,
      ),
      Expense(
        id: '15',
        amount: const Money(320000),
        description: 'Supermarket',
        date: now.subtract(const Duration(days: 7, hours: 3)),
        category: categories['Shopping']!,
      ),
    ];
  }

  Future<List<Expense>> getExpenses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_mockExpenses);
  }

  Future<Expense> addExpense(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockExpenses.insert(0, expense);
    return expense;
  }

  Future<Expense> updateExpense(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockExpenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _mockExpenses[index] = expense;
    }
    return expense;
  }
}
