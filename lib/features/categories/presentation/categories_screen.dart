import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/category_provider.dart';
import '../../expenses/state/expense_provider.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/async_error_view.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoryProvider);
    final expensesState = ref.watch(expensesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF232340) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Categories',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: categoriesState.when(
        data: (categories) {
          final expenses = expensesState.value ?? [];

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final catExpenses = expenses
                  .where((e) => e.category.id == cat.id)
                  .toList();
              final totalSpentPaise = catExpenses.fold<int>(
                0,
                (sum, e) => sum + e.amount.paise,
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00897B).withAlpha(20),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat.icon,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${catExpenses.length} transactions recorded',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Money(totalSpentPaise).formatted,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00897B),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00897B)),
        ),
        error: (e, s) => AsyncErrorView(
          error: e,
          onRetry: () => ref.refresh(categoryProvider),
        ),
      ),
    );
  }
}
