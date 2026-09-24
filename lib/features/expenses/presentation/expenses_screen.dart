import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/expense_provider.dart';
import '../widgets/expense_card.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../app/routes.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  String _selectedCategoryFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final expensesState = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Transactions',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.addExpense),
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Expense',
          ),
        ],
      ),
      body: expensesState.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(message: 'No transactions recorded yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => context.push(AppRoutes.addExpense),
                    icon: const Icon(Icons.add),
                    label: const Text('Add your first expense'),
                  ),
                ],
              ),
            );
          }

          // Extract unique categories for filter tabs
          final categories = <String, String>{};
          for (final e in expenses) {
            categories[e.category.id] = '${e.category.icon} ${e.category.name}';
          }

          final filteredExpenses = _selectedCategoryFilter == 'all'
              ? expenses
              : expenses
                    .where((e) => e.category.id == _selectedCategoryFilter)
                    .toList();

          final totalFilteredPaise = filteredExpenses.fold<int>(
            0,
            (sum, e) => sum + e.amount.paise,
          );

          return Column(
            children: [
              // Filter chips bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All (${expenses.length})',
                      isSelected: _selectedCategoryFilter == 'all',
                      onTap: () =>
                          setState(() => _selectedCategoryFilter = 'all'),
                    ),
                    ...categories.entries.map((entry) {
                      final isSelected = _selectedCategoryFilter == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _FilterChip(
                          label: entry.value,
                          isSelected: isSelected,
                          onTap: () => setState(
                            () => _selectedCategoryFilter = entry.key,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Summary banner for active filter
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredExpenses.length} items',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Total: Rs. ${(totalFilteredPaise / 100).toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00897B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Transactions list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) =>
                      ExpenseCard(expense: filteredExpenses[index]),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00897B)),
        ),
        error: (error, stack) => AsyncErrorView(
          error: error,
          onRetry: () => ref.read(expensesProvider.notifier).loadExpenses(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00897B),
        onPressed: () => context.push(AppRoutes.addExpense),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00897B)
              : (isDark ? Colors.white10 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }
}
