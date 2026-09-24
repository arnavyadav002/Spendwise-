import 'dart:async';

import 'package:dio/dio.dart';

import '../../features/expenses/domain/models/expense.dart';
import '../../features/expenses/domain/models/expense_category.dart';
import '../../features/budgets/domain/models/budget.dart';
import '../../features/auth/domain/models/user_model.dart';
import '../utils/money.dart';

/// In-memory mock backend database that persists state during app runtime.
class MockBackendDatabase {
  static final MockBackendDatabase instance = MockBackendDatabase._();
  MockBackendDatabase._() {
    _initDefaultData();
  }

  final List<ExpenseCategory> categories = [];
  final List<Expense> expenses = [];
  final List<Budget> budgets = [];
  final Map<String, String> validTokens = {};

  void _initDefaultData() {
    categories.clear();
    expenses.clear();
    budgets.clear();

    final defaultCategories = [
      const ExpenseCategory(id: 'c1', name: 'Food & Dining', icon: '🍔'),
      const ExpenseCategory(id: 'c2', name: 'Transport', icon: '🚗'),
      const ExpenseCategory(id: 'c3', name: 'Entertainment', icon: '🎬'),
      const ExpenseCategory(id: 'c4', name: 'Shopping', icon: '🛍️'),
      const ExpenseCategory(id: 'c5', name: 'Bills & Utilities', icon: '💡'),
    ];
    categories.addAll(defaultCategories);

    final now = DateTime.now();
    final defaultExpenses = [
      Expense(
        id: '1',
        amount: const Money(35000),
        description: 'Starbucks Coffee',
        date: now.subtract(const Duration(hours: 2)),
        category: defaultCategories[0],
      ),
      Expense(
        id: '2',
        amount: const Money(245000),
        description: 'Grocery at FreshMart',
        date: now.subtract(const Duration(hours: 5)),
        category: defaultCategories[3],
      ),
      Expense(
        id: '3',
        amount: const Money(85000),
        description: 'Uber to Airport',
        date: now.subtract(const Duration(days: 1)),
        category: defaultCategories[1],
      ),
      Expense(
        id: '4',
        amount: const Money(64900),
        description: 'Netflix Subscription',
        date: now.subtract(const Duration(days: 1, hours: 4)),
        category: defaultCategories[2],
      ),
      Expense(
        id: '5',
        amount: const Money(180000),
        description: 'Electricity Bill',
        date: now.subtract(const Duration(days: 2)),
        category: defaultCategories[4],
      ),
      Expense(
        id: '6',
        amount: const Money(129900),
        description: 'Zara T-Shirt',
        date: now.subtract(const Duration(days: 2, hours: 2)),
        category: defaultCategories[3],
      ),
      Expense(
        id: '7',
        amount: const Money(85000),
        description: 'Pizza Hut Delivery',
        date: now.subtract(const Duration(days: 3)),
        category: defaultCategories[0],
      ),
      Expense(
        id: '8',
        amount: const Money(50000),
        description: 'Metro Recharge',
        date: now.subtract(const Duration(days: 3, hours: 5)),
        category: defaultCategories[1],
      ),
      Expense(
        id: '9',
        amount: const Money(90000),
        description: 'Cinema Tickets',
        date: now.subtract(const Duration(days: 4)),
        category: defaultCategories[2],
      ),
      Expense(
        id: '10',
        amount: const Money(40000),
        description: 'Water Bill',
        date: now.subtract(const Duration(days: 4, hours: 8)),
        category: defaultCategories[4],
      ),
      Expense(
        id: '11',
        amount: const Money(55000),
        description: 'Swiggy Dinner',
        date: now.subtract(const Duration(days: 5)),
        category: defaultCategories[0],
      ),
      Expense(
        id: '12',
        amount: const Money(149900),
        description: 'Amazon Prime',
        date: now.subtract(const Duration(days: 6)),
        category: defaultCategories[2],
      ),
      Expense(
        id: '13',
        amount: const Money(200000),
        description: 'Petrol',
        date: now.subtract(const Duration(days: 6, hours: 1)),
        category: defaultCategories[1],
      ),
      Expense(
        id: '14',
        amount: const Money(450000),
        description: 'Headphones',
        date: now.subtract(const Duration(days: 7)),
        category: defaultCategories[3],
      ),
      Expense(
        id: '15',
        amount: const Money(320000),
        description: 'Supermarket',
        date: now.subtract(const Duration(days: 7, hours: 3)),
        category: defaultCategories[3],
      ),
    ];
    expenses.addAll(defaultExpenses);

    budgets.addAll([
      Budget(
        id: 'b1',
        categoryId: 'c1',
        limit: const Money(1500000), // 15,000 limit
        spent: Money(_calculateCategorySpent('c1')),
      ),
      Budget(
        id: 'b2',
        categoryId: 'c2',
        limit: const Money(800000), // 8,000 limit
        spent: Money(_calculateCategorySpent('c2')),
      ),
      Budget(
        id: 'b3',
        categoryId: 'c4',
        limit: const Money(2000000), // 20,000 limit
        spent: Money(_calculateCategorySpent('c4')),
      ),
    ]);
  }

  int _calculateCategorySpent(String catId) {
    final now = DateTime.now();
    return expenses
        .where(
          (e) =>
              e.category.id == catId &&
              e.date.year == now.year &&
              e.date.month == now.month,
        )
        .fold<int>(0, (sum, e) => sum + e.amount.paise);
  }

  void reset() {
    _initDefaultData();
    validTokens.clear();
  }
}

/// Dio Interceptor that intercepts all requests to the mock backend API
/// and serves them from [MockBackendDatabase] with realistic JSON responses.
class MockBackendInterceptor extends Interceptor {
  final MockBackendDatabase _db = MockBackendDatabase.instance;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add realistic mock API latency
    await Future.delayed(const Duration(milliseconds: 100));

    final path = options.path.replaceAll(RegExp(r'^https?://[^/]+'), '');
    final method = options.method.toUpperCase();

    // 1. Auth: /auth/login
    if (path == '/auth/login' && method == 'POST') {
      final body = options.data is Map<String, dynamic>
          ? options.data
          : <String, dynamic>{};
      final username = (body['username'] as String?)?.trim() ?? 'User';
      final password = body['password'] as String? ?? '';

      if (password != '1234') {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data: {'message': 'Invalid password. Hint: use 1234.'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      final token = 'token_${DateTime.now().millisecondsSinceEpoch}_$username';
      _db.validTokens[token] = username;

      final user = UserModel(
        id: 'u_1',
        email: '$username@spendwise.app',
        name: username,
      );

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'token': token, 'user': user.toJson()},
        ),
      );
    }

    // 2. Expenses: GET /expenses
    if (path == '/expenses' && method == 'GET') {
      final sorted = List<Expense>.from(_db.expenses)
        ..sort((a, b) => b.date.compareTo(a.date));
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: sorted.map((e) => e.toJson()).toList(),
        ),
      );
    }

    // 3. Expenses: POST /expenses
    if (path == '/expenses' && method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      final expense = Expense.fromJson(data);
      // Insert at beginning
      _db.expenses.insert(0, expense);

      // Refresh corresponding budget spent amount
      final bIndex = _db.budgets.indexWhere(
        (b) => b.categoryId == expense.category.id,
      );
      if (bIndex != -1) {
        final b = _db.budgets[bIndex];
        final newSpent = _db._calculateCategorySpent(b.categoryId);
        _db.budgets[bIndex] = Budget(
          id: b.id,
          categoryId: b.categoryId,
          limit: b.limit,
          spent: Money(newSpent),
        );
      }

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: expense.toJson(),
        ),
      );
    }

    // 4. Expenses: GET /expenses/:id
    final expenseIdMatch = RegExp(r'^/expenses/([^/]+)$').firstMatch(path);
    if (expenseIdMatch != null && method == 'GET') {
      final id = expenseIdMatch.group(1);
      final expense = _db.expenses.where((e) => e.id == id).firstOrNull;
      if (expense == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 404,
              data: {'message': 'Expense not found'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: expense.toJson(),
        ),
      );
    }

    // 5. Expenses: PUT /expenses/:id
    if (expenseIdMatch != null && method == 'PUT') {
      final id = expenseIdMatch.group(1);
      final index = _db.expenses.indexWhere((e) => e.id == id);
      if (index == -1) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 404),
            type: DioExceptionType.badResponse,
          ),
        );
      }
      final updated = Expense.fromJson(options.data as Map<String, dynamic>);
      _db.expenses[index] = updated;
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: updated.toJson(),
        ),
      );
    }

    // 6. Expenses: DELETE /expenses/:id
    if (expenseIdMatch != null && method == 'DELETE') {
      final id = expenseIdMatch.group(1);
      _db.expenses.removeWhere((e) => e.id == id);
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'success': true},
        ),
      );
    }

    // 7. Dashboard: GET /dashboard
    if (path == '/dashboard' && method == 'GET') {
      final now = DateTime.now();
      final monthlyExpenses =
          _db.expenses
              .where(
                (e) => e.date.year == now.year && e.date.month == now.month,
              )
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));

      final categoryTotals = <String, int>{};
      int totalSpent = 0;
      for (final e in monthlyExpenses) {
        categoryTotals[e.category.id] =
            (categoryTotals[e.category.id] ?? 0) + e.amount.paise;
        totalSpent += e.amount.paise;
      }

      final categoryPercentages = <String, double>{};
      if (totalSpent > 0) {
        categoryTotals.forEach((catId, amt) {
          categoryPercentages[catId] = amt / totalSpent;
        });
      }

      final recent = List<Expense>.from(_db.expenses)
        ..sort((a, b) => b.date.compareTo(a.date));

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'totalBalance': 12500000, // 125,000.00
            'monthlySpending': totalSpent,
            'recentExpenses': recent.take(6).map((e) => e.toJson()).toList(),
            'categoryPercentages': categoryPercentages,
          },
        ),
      );
    }

    // 8. Analytics: GET /analytics
    if (path.startsWith('/analytics') && method == 'GET') {
      final now = DateTime.now();
      final month =
          int.tryParse(options.queryParameters['month']?.toString() ?? '') ??
          now.month;
      final year =
          int.tryParse(options.queryParameters['year']?.toString() ?? '') ??
          now.year;

      final filtered = _db.expenses
          .where((e) => e.date.year == year && e.date.month == month)
          .toList();

      final categoryBreakdown = <String, int>{};
      int totalSpent = 0;
      for (final e in filtered) {
        categoryBreakdown[e.category.name] =
            (categoryBreakdown[e.category.name] ?? 0) + e.amount.paise;
        totalSpent += e.amount.paise;
      }

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'totalSpent': totalSpent,
            'categoryBreakdown': categoryBreakdown,
          },
        ),
      );
    }

    // 9. Budgets: GET /budgets
    if (path == '/budgets' && method == 'GET') {
      // Recompute spent for each budget dynamically
      final list = _db.budgets.map((b) {
        final currentSpent = _db._calculateCategorySpent(b.categoryId);
        return Budget(
          id: b.id,
          categoryId: b.categoryId,
          limit: b.limit,
          spent: Money(currentSpent),
        );
      }).toList();

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: list.map((b) => b.toJson()).toList(),
        ),
      );
    }

    // 10. Budgets: POST /budgets
    if (path == '/budgets' && method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      final b = Budget.fromJson(data);
      final currentSpent = _db._calculateCategorySpent(b.categoryId);
      final newBudget = Budget(
        id: b.id.isEmpty ? 'b_${DateTime.now().millisecondsSinceEpoch}' : b.id,
        categoryId: b.categoryId,
        limit: b.limit,
        spent: Money(currentSpent),
      );
      _db.budgets.removeWhere(
        (item) => item.categoryId == newBudget.categoryId,
      );
      _db.budgets.add(newBudget);

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: newBudget.toJson(),
        ),
      );
    }

    // 11. Categories: GET /categories
    if (path == '/categories' && method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _db.categories.map((c) => c.toJson()).toList(),
        ),
      );
    }

    // Default: pass through or reject
    handler.next(options);
  }
}
