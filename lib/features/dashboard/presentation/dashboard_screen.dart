import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/dashboard_provider.dart';
import '../../auth/state/auth_provider.dart';
import '../../expenses/widgets/expense_card.dart';
import 'widgets/category_pie_chart.dart';
import 'widgets/weekly_bar_chart.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../app/app.dart';
import '../../../app/routes.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final user = ref.watch(authProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF232340) : Colors.white;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              break; // Already on dashboard
            case 1:
              context.push(AppRoutes.expenses);
              break;
            case 2:
              context.push(AppRoutes.budgets);
              break;
            case 3:
              context.push(AppRoutes.analytics);
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings_rounded),
            label: 'Budgets',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics_rounded),
            label: 'Analytics',
          ),
        ],
      ),
      body: dashboardState.when(
        data: (data) => RefreshIndicator(
          color: const Color(0xFF00897B),
          onRefresh: () async => ref.refresh(dashboardProvider.future),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ─── Header ───
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 20,
                    right: 20,
                    bottom: 24,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Greeting & actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good ${_greeting()},',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user?.name ?? 'User',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Dark/Light toggle
                              IconButton(
                                onPressed: () => ref
                                    .read(themeModeProvider.notifier)
                                    .toggle(),
                                icon: Icon(
                                  isDark
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_rounded,
                                  color: Colors.grey.shade500,
                                  size: 22,
                                ),
                                tooltip: 'Toggle theme',
                              ),
                              const SizedBox(width: 4),
                              // Profile avatar
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.profile),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFF00897B)
                                      .withAlpha(25),
                                  child: Text(
                                    (user?.name ?? 'U')[0].toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF00897B),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Monthly Spending Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00897B), Color(0xFF00695C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00897B).withAlpha(40),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spent this month',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.monthlySpending.formatted,
                              style: GoogleFonts.inter(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick Action Pills
                      Row(
                        children: [
                          _QuickActionButton(
                            icon: Icons.add_circle_outline_rounded,
                            label: 'Add Expense',
                            color: const Color(0xFF00897B),
                            onTap: () => context.push(AppRoutes.addExpense),
                          ),
                          const SizedBox(width: 10),
                          _QuickActionButton(
                            icon: Icons.savings_outlined,
                            label: 'Set Budget',
                            color: Colors.blueAccent,
                            onTap: () => context.push(AppRoutes.createBudget),
                          ),
                          const SizedBox(width: 10),
                          _QuickActionButton(
                            icon: Icons.bar_chart_rounded,
                            label: 'Analytics',
                            color: Colors.purpleAccent,
                            onTap: () => context.push(AppRoutes.analytics),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Body ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryPieChart(percentages: data.categoryPercentages),
                      const SizedBox(height: 16),
                      const WeeklyBarChart(),
                      const SizedBox(height: 26),

                      // Recent Transactions Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF00897B),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () => context.push(AppRoutes.expenses),
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                            ),
                            label: Text(
                              'See all',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (data.recentExpenses.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(28),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'No transactions recorded yet.\nTap "Add Expense" above to start!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        )
                      else ...[
                        ...data.recentExpenses
                            .take(6)
                            .map((e) => ExpenseCard(expense: e)),

                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.white10
                                  : Colors.grey.shade200,
                              foregroundColor: isDark
                                  ? Colors.white
                                  : Colors.black87,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => context.push(AppRoutes.expenses),
                            icon: const Icon(Icons.list_alt_rounded, size: 18),
                            label: Text(
                              'View all transactions (${data.recentExpenses.length})',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00897B)),
        ),
        error: (error, stack) => AsyncErrorView(
          error: error,
          onRetry: () => ref.refresh(dashboardProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00897B),
        onPressed: () => context.push(AppRoutes.addExpense),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Expense',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: isDark ? Colors.white10 : color.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
