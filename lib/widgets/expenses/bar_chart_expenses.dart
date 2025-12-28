// lib/widgets/expenses/expense_category_barchart.dart
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/alternative_colors.dart';
import '../../models/expense_model.dart';

/* ───────────────────────── helpers ───────────────────────── */

class _BarData {
  const _BarData(this.catKey, this.color, this.value, this.shadowValue);

  final String catKey;

  final Color color;

  final double value, shadowValue;
}

String _translateCategory(String key) {
  switch (key) {
    case 'logistics':
      return 'Logística';
    case 'food':
      return 'Comida';
    case 'catering':
      return 'Banquete';
    case 'decoration':
      return 'Decoración';
    case 'transport':
      return 'Transporte';
    case 'marketing':
      return 'Publicidad';
    case 'other':
      return 'Otro';
    case 'music':
      return 'Música';
    default:
      return key[0].toUpperCase() + key.substring(1);
  }
}

/* ───────────────────────── widget ───────────────────────── */

class ExpenseCategoryBarChart extends StatefulWidget {
  const ExpenseCategoryBarChart({super.key, required this.expenses});

  final List<ExpenseModel> expenses;

  Color get shadowColor => const Color(0xFFCCCCCC);

  @override
  State<ExpenseCategoryBarChart> createState() =>
      _ExpenseCategoryBarChartState();
}

class _ExpenseCategoryBarChartState extends State<ExpenseCategoryBarChart> {
  int _touchedGroupIndex = -1;
  final int _rotationTurns = 1;

  /* ------------------------------- builder -------------------------------- */

  @override
  Widget build(BuildContext context) {
    final totals = <String, double>{};
    for (final e in widget.expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }

    final maxValue =
        totals.values.isEmpty ? 0.0 : totals.values.reduce(math.max) * 1.2;

    final dataList =
        totals.entries.toList().asMap().entries.map((entry) {
          final idx = entry.key;
          final catKey = entry.value.key;
          final val = entry.value.value;
          return _BarData(
            catKey,
            PartyColors.categoryColors[idx % PartyColors.categoryColors.length],
            val,
            maxValue,
          );
        }).toList();

    /* 3. UI ----------------------------------------------------------- */
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                'Gastos por Categoría',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                rotationQuarterTurns: _rotationTurns,
                maxY: maxValue,
                /* ------- Grid & bordes ------- */
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (_) => FlLine(
                        color: widget.shadowColor.withValues(alpha: 0.25),
                        strokeWidth: 1,
                      ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.symmetric(
                    horizontal: BorderSide(color: widget.shadowColor),
                  ),
                ),
                /* ------- Ejes / etiquetas ------- */
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 46,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= dataList.length) {
                          return const SizedBox.shrink();
                        }
                        final data = dataList[idx];
                        return _IconWidget(
                          color: data.color,
                          isSelected: _touchedGroupIndex == idx,
                          label: _translateCategory(data.catKey),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                ),
                /* ------- Barras ------- */
                barGroups:
                    dataList
                        .asMap()
                        .entries
                        .map((e) => _makeGroup(e.value, e.key))
                        .toList(),
                /* ------- Interacción / tooltip ------- */
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions &&
                        response != null &&
                        response.spot != null) {
                      setState(
                        () =>
                            _touchedGroupIndex =
                                response.spot!.touchedBarGroupIndex,
                      );
                    } else {
                      setState(() => _touchedGroupIndex = -1);
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipMargin: 0,
                    getTooltipItem:
                        (_, __, rod, ___) => BarTooltipItem(
                          '\$${rod.toY.toStringAsFixed(0)}',
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            color: rod.color,
                            fontSize: 18,
                            shadows: const [
                              Shadow(color: Colors.black26, blurRadius: 12),
                            ],
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* --------------------------- helpers intern ------------------------- */

  /// Genera cada group con barra + sombra
  BarChartGroupData _makeGroup(_BarData d, int x) {
    final showTip = _touchedGroupIndex == x;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: d.shadowValue,
          color: widget.shadowColor,
          width: 12,
        ),
        BarChartRodData(
          toY: d.value,
          color: d.color,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      showingTooltipIndicators: showTip ? [1] : [],
    );
  }
}

/* ───────────────── etiqueta animada ───────────────── */

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
  Tween<double>? _tween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tween =
        visitor(
              _tween,
              widget.isSelected ? 1.0 : 0.0,
              (v) => Tween<double>(
                begin: v as double,
                end: widget.isSelected ? 1.0 : 0.0,
              ),
            )
            as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final t = _tween!.evaluate(animation);
    return Transform(
      transform:
          Matrix4.rotationZ(math.pi * 2 * t)..scaleByDouble(1 + 0.4 * t),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: widget.color, size: 12),
          const SizedBox(height: 4),
          Text(widget.label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
