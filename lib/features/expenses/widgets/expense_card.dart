import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/routes.dart';
import '../../../core/utils/date_format.dart';
import '../domain/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  static const _bgColors = <String, Color>{
    'c1': Color(0xFFFFF3E0),
    'c2': Color(0xFFE1F5FE),
    'c3': Color(0xFFF3E5F5),
    'c4': Color(0xFFFCE4EC),
    'c5': Color(0xFFE8F5E9),
  };

  static const _darkBgColors = <String, Color>{
    'c1': Color(0xFF3E2723),
    'c2': Color(0xFF0D2137),
    'c3': Color(0xFF2A1030),
    'c4': Color(0xFF371525),
    'c5': Color(0xFF1B3020),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? (_darkBgColors[expense.category.id] ?? Colors.grey.shade800)
        : (_bgColors[expense.category.id] ?? Colors.grey.shade100);
    final cardColor = isDark ? const Color(0xFF232340) : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push(AppRoutes.expenseDetailsPath(expense.id)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    expense.category.icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.description,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${expense.category.name}  ·  ${DateFormatter.formatShort(expense.date)}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '- ${expense.amount.formatted}',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE53935),
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
