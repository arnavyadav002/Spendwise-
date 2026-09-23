import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF232340) : Colors.white;

    final data = [
      _BarData('Mon', 3200),
      _BarData('Tue', 5100),
      _BarData('Wed', 2400),
      _BarData('Thu', 7800),
      _BarData('Fri', 4500),
      _BarData('Sat', 6200),
      _BarData('Sun', 3800),
    ];

    final maxVal = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((d) {
                final ratio = d.value / maxVal;
                final isMax = d.value == maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          height: 100 * ratio,
                          decoration: BoxDecoration(
                            color: isMax
                                ? const Color(0xFF00897B)
                                : const Color(0xFF00897B).withAlpha(60),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          d.label,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isMax
                                ? const Color(0xFF00897B)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String label;
  final double value;
  const _BarData(this.label, this.value);
}
