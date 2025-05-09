// lib/widgets/expenses/expense_distribution_piechart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/alternative_colors.dart';
import '../../models/expense_model.dart';

class ExpenseDistributionPieChart extends StatefulWidget {
  final List<ExpenseModel> expenses;

  const ExpenseDistributionPieChart({super.key, required this.expenses});

  @override
  State<ExpenseDistributionPieChart> createState() =>
      _ExpenseDistributionPieChartState();
}

class _ExpenseDistributionPieChartState
    extends State<ExpenseDistributionPieChart> {
  int _touchedIndex = -1;

  // Mapea cada categoría a un asset de imagen local
  final Map<String, String> _categoryImages = {
    'food': 'assets/images/icon_food.png',
    'catering': 'assets/images/icon_catering.png',
    'logistics': 'assets/images/icon_logistics.png',
    'decoration': 'assets/images/icon_decoration.png',
    'music': 'assets/images/icon_music.png',
  };

  // Traduce categoría a español
  String _translateCategory(String key) {
    switch (key) {
      case 'food':
        return 'Comida';
      case 'catering':
        return 'Banquete';
      case 'logistics':
        return 'Logística';
      case 'decoration':
        return 'Decoración';
      case 'music':
        return 'Música';
      default:
        return key[0].toUpperCase() + key.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Agrupa montos por categoría
    final totals = <String, double>{};
    for (final e in widget.expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    final entries = totals.entries.toList();
    final totalSpent = entries.fold<double>(0, (sum, e) => sum + e.value);

    return AspectRatio(
      aspectRatio: 1.4,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (event.isInterestedForInteractions &&
                    response != null &&
                    response.touchedSection != null) {
                  _touchedIndex = response.touchedSection!.touchedSectionIndex;
                } else {
                  _touchedIndex = -1;
                }
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 12,
          centerSpaceRadius: 50,
          sections: List.generate(entries.length, (i) {
            final entry = entries[i];
            final percent =
                totalSpent > 0 ? (entry.value / totalSpent) * 100 : 0.0;
            final isTouched = i == _touchedIndex;
            final radius = isTouched ? 90.0 : 80.0;
            final fontSize = isTouched ? 14.0 : 18.0;
            final imageSize = isTouched ? 60.0 : 60.0;
            final color =
                PartyColors.categoryColors[i %
                    PartyColors.categoryColors.length];

            final label = _translateCategory(entry.key);

            return PieChartSectionData(
              color: color,
              value: entry.value,
              title: '${percent.toStringAsFixed(0)}%\n',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [Shadow(blurRadius: 3, color: Colors.black45)],
              ),
              titlePositionPercentageOffset: 0.35,
              badgeWidget: _Badge(
                _categoryImages[entry.key] ??
                    'assets/images/icon_decoration.png',
                size: imageSize,
                borderColor: Colors.black.withValues(alpha: 0.4),
              ),
              badgePositionPercentageOffset: .98,
            );
          }),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.assetPath, {required this.size, required this.borderColor});

  final String assetPath;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: Image.asset(assetPath, fit: BoxFit.contain)),
    );
  }
}
