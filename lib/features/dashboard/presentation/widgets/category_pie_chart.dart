import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../expenses/domain/models/expense_category.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<ExpenseCategory, double> percentages;

  const CategoryPieChart({super.key, required this.percentages});

  static const _categoryColors = <String, Color>{
    'c1': Color(0xFFFF8A65),
    'c2': Color(0xFF4FC3F7),
    'c3': Color(0xFFBA68C8),
    'c4': Color(0xFFF06292),
    'c5': Color(0xFF81C784),
  };

  Color _colorFor(String id) => _categoryColors[id] ?? Colors.grey;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF232340) : Colors.white;
    final data = percentages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
            'Where your money goes',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: CustomPaint(
                  painter: _DonutPainter(
                    percentages: data.map((e) => e.value).toList(),
                    colors: data.map((e) => _colorFor(e.key.id)).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 28),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.map((e) {
                    final color = _colorFor(e.key.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              e.key.name,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Text(
                            '${(e.value * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;

  _DonutPainter({required this.percentages, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 22.0;
    const gap = 0.04;
    double startAngle = -pi / 2;

    for (int i = 0; i < percentages.length; i++) {
      final sweepAngle = 2 * pi * percentages[i] - gap;
      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle + gap / 2,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
