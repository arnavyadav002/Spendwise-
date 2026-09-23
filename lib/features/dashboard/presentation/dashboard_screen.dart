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
                    top: MediaQuery.of(context).padding.top + 20,
                    left: 24,
                    right: 24,
                    bottom: 28,
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
                      // Top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good ${_greeting()},',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user?.name ?? 'User',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Dark / Light mode toggle
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
                              ),
                              const SizedBox(width: 4),
                              // Logout
                              GestureDetector(
                                onTap: () =>
                                    ref.read(authProvider.notifier).logout(),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: const Color(0xFF00897B)
                                      .withAlpha(25),
                                  child: Text(
                                    (user?.name ?? 'U')[0].toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
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
                      const SizedBox(height: 24),

                      // Spending card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00897B), Color(0xFF00695C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
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
                    ],
                  ),
                ),
              ),

              // ─── Body ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryPieChart(percentages: data.categoryPercentages),
                      const SizedBox(height: 16),
                      const WeeklyBarChart(),
                      const SizedBox(height: 28),

                      // Recent transactions header
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
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.expenses),
                            child: Text(
                              'See all',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF00897B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      ...data.recentExpenses
                          .take(6)
                          .map((e) => ExpenseCard(expense: e)),

                      if (data.recentExpenses.length > 6)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: TextButton(
                              onPressed: () => context.push(AppRoutes.expenses),
                              child: Text(
                                'View all transactions',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF00897B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

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
        onPressed: () => context.push(AppRoutes.addExpense),
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Add',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
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
