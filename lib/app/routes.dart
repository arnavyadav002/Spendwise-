class AppRoutes {
  static const login = '/login';
  static const dashboard = '/';
  static const expenses = '/expenses';
  static const addExpense = '/add-expense';
  static const expenseDetails = '/expense-details';
  static const analytics = '/analytics';
  static const budgets = '/budgets';
  static const createBudget = '/create-budget';
  static const categories = '/categories';
  static const profile = '/profile';

  static String expenseDetailsPath(String id) => '$expenseDetails/$id';
}
