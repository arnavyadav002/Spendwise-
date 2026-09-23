import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import '../features/auth/state/auth_provider.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/profile_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/expenses/presentation/expenses_screen.dart';
import '../features/expenses/presentation/add_expense_screen.dart';
import '../features/expenses/presentation/expense_details_screen.dart';
import '../features/analytics/presentation/analytics_screen.dart';
import '../features/budgets/presentation/budgets_screen.dart';
import '../features/budgets/presentation/create_budget_screen.dart';
import '../features/categories/presentation/categories_screen.dart';

// Listenable that bridges Riverpod auth state → GoRouter refreshes,
// so we don't recreate the entire GoRouter on every auth change.
class _AuthNotifierListenable extends ChangeNotifier {
  _AuthNotifierListenable(this._ref) {
    _ref.listen(authProvider, (previous, next) => notifyListeners());
  }
  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = _AuthNotifierListenable(ref);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    refreshListenable: authListenable,
    redirect: (context, state) {
      final isAuth = ref.read(authProvider).isAuthenticated;
      final isLoginRoute = state.uri.toString() == AppRoutes.login;

      if (!isAuth && !isLoginRoute) return AppRoutes.login;
      if (isAuth && isLoginRoute) return AppRoutes.dashboard;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.expenses,
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: AppRoutes.addExpense,
        builder: (context, state) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: AppRoutes.expenseDetails,
        builder: (context, state) =>
            ExpenseDetailsScreen(expenseId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '${AppRoutes.expenseDetails}/:id',
        builder: (context, state) =>
            ExpenseDetailsScreen(expenseId: state.pathParameters['id']),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.budgets,
        builder: (context, state) => const BudgetsScreen(),
      ),
      GoRoute(
        path: AppRoutes.createBudget,
        builder: (context, state) => const CreateBudgetScreen(),
      ),
      GoRoute(
        path: AppRoutes.categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
