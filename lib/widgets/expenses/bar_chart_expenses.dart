// lib/widgets/expenses/expense_category_barchart.dart
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/alternative_colors.dart';
import '../../models/expense_model.dart';

// modelo auxiliar para cada barra
class _BarData {
  const _BarData(this.category, this.color, this.value, this.shadowValue);
  final String category;
  final Color color;
  final double value;
  final double shadowValue;
}

class ExpenseCategoryBarChart extends StatefulWidget {
  final List<ExpenseModel> expenses;
  const ExpenseCategoryBarChart({super.key, required this.expenses});

  get shadowColor => null;

  @override
  State<ExpenseCategoryBarChart> createState() =>
      _ExpenseCategoryBarChartState();
}

class _ExpenseCategoryBarChartState extends State<ExpenseCategoryBarChart> {
  int _touchedGroupIndex = -1;
  int _rotationTurns = 1;

  BarChartGroupData _makeGroup(_BarData data, int x) {
    final showTooltip = _touchedGroupIndex == x;
    return BarChartGroupData(
      x: x,
      barRods: [
        // sombra (fondo)
        BarChartRodData(
          toY: data.shadowValue,
          color: widget.shadowColor,
          width: 12,
        ),
        // valor real
        BarChartRodData(
          toY: data.value,
          color: data.color,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      showingTooltipIndicators: showTooltip ? [1] : [],
    );
  }

  Color get shadowColor => const Color(0xFFCCCCCC);

  @override
  Widget build(BuildContext context) {
    // Agrega totales por categoría
    final totals = <String, double>{};
    for (var e in widget.expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }

    // Construye la lista de datos
    final maxValue =
        totals.values.isEmpty ? 0.0 : totals.values.reduce(math.max) * 1.2;
    final dataList =
        totals.entries.toList().asMap().entries.map((entry) {
          final idx = entry.key;
          final cat = entry.value.key;
          final val = entry.value.value;
          final color =
              PartyColors.categoryColors[idx %
                  PartyColors.categoryColors.length];
          return _BarData(cat, color, val, maxValue);
        }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Título y botón de rotación
          Row(
            children: [
              Expanded(child: Container()),
              Text(
                'Gastos por Categoría',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(child: Align(alignment: Alignment.centerRight)),
            ],
          ),
          const SizedBox(height: 18),
          // El BarChart
          AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                rotationQuarterTurns: _rotationTurns,
                maxY: maxValue,
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchCallback: (e, resp) {
                    setState(() {
                      if (e.isInterestedForInteractions &&
                          resp != null &&
                          resp.spot != null) {
                        _touchedGroupIndex = resp.spot!.touchedBarGroupIndex;
                      } else {
                        _touchedGroupIndex = -1;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipMargin: 0,
                    getTooltipItem: (_, __, rod, ___) {
                      return BarTooltipItem(
                        '\$${rod.toY.toStringAsFixed(0)}',
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          color: rod.color,
                          fontSize: 18,
                          shadows: const [
                            Shadow(color: Colors.black26, blurRadius: 12),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    drawBelowEverything: true,
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= dataList.length) {
                          return const SizedBox.shrink();
                        }
                        final data = dataList[idx];
                        return _IconWidget(
                          color: data.color,
                          isSelected: _touchedGroupIndex == idx,
                          label: data.category,
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (v) => FlLine(
                        color: shadowColor.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.symmetric(
                    horizontal: BorderSide(color: shadowColor, width: 1),
                  ),
                ),
                barGroups:
                    dataList
                        .asMap()
                        .entries
                        .map((e) => _makeGroup(e.value, e.key))
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icono animado para cada etiqueta de categoría
class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
    required this.label,
  }) : super(duration: const Duration(milliseconds: 300));

  final Color color;
  final bool isSelected;
  final String label;

  @override
  AnimatedWidgetBaseState<_IconWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween =
        visitor(
              _rotationTween,
              widget.isSelected ? 1.0 : 0.0,
              (v) => Tween<double>(
                begin: v as double,
                end: widget.isSelected ? 1 : 0,
              ),
            )
            as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 2 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.4;

    return Transform(
      transform: Matrix4.rotationZ(rotation)..scale(scale, scale),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: widget.color, size: 12),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: TextStyle(color: Colors.black87, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
