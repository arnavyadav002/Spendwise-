import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/budget_provider.dart';
import '../../categories/state/category_provider.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../app/routes.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsState = ref.watch(budgetsProvider);
    final categoriesState = ref.watch(categoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF232340) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Monthly Budgets',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: budgetsState.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(message: 'No budgets set yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => context.push(AppRoutes.createBudget),
                    icon: const Icon(Icons.add),
                    label: const Text('Create a Budget'),
                  ),
                ],
              ),
            );
          }

          final totalLimitPaise = budgets.fold<int>(
            0,
            (sum, b) => sum + b.limit.paise,
          );
          final totalSpentPaise = budgets.fold<int>(
            0,
            (sum, b) => sum + b.spent.paise,
          );
          final totalProgress = totalLimitPaise > 0
              ? (totalSpentPaise / totalLimitPaise).clamp(0.0, 1.0)
              : 0.0;

          final categories = categoriesState.value ?? [];
          final catMap = {for (var c in categories) c.id: c};

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              // Total budget overview card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF00695C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Budget Pool',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Rs. ${(totalSpentPaise / 100).toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '/ Rs. ${(totalLimitPaise / 100).toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: totalProgress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          totalProgress > 0.9
                              ? Colors.redAccent
                              : Colors.tealAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(totalProgress * 100).toStringAsFixed(0)}% used of overall budget',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Category Allocations',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              ...budgets.map((b) {
                final cat = catMap[b.categoryId];
                final catName = cat?.name ?? 'Category';
                final catIcon = cat?.icon ?? '🏷️';
                final progress = b.progress;
                final isOver = b.spent.paise > b.limit.paise;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00897B).withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              catIcon,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  catName,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isOver
                                      ? 'Exceeded by ${b.spent - b.limit}'
                                      : '${b.limit - b.spent} remaining',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isOver
                                        ? Colors.redAccent
                                        : Colors.grey.shade500,
                                    fontWeight: isOver
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isOver
                                  ? Colors.redAccent
                                  : const Color(0xFF00897B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: isDark
                              ? Colors.white10
                              : Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isOver
                                ? Colors.redAccent
                                : (progress > 0.8
                                      ? Colors.orangeAccent
                                      : const Color(0xFF00897B)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Spent: ${b.spent.formatted}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            'Limit: ${b.limit.formatted}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00897B)),
        ),
        error: (e, s) => AsyncErrorView(
          error: e,
          onRetry: () => ref.read(budgetsProvider.notifier).loadBudgets(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00897B),
        onPressed: () => context.push(AppRoutes.createBudget),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Set Budget',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
