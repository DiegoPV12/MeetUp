// lib/widgets/guests_overview/rsvp_trend_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/guest_model.dart';

class RsvpTrendChart extends StatelessWidget {
  final List<GuestModel> guests;
  const RsvpTrendChart({super.key, required this.guests});

  @override
  Widget build(BuildContext context) {
    // mapa fecha (yyyy-MM-dd) -> count
    final now = DateTime.now();
    final df = DateFormat('yyyy-MM-dd');
    final map = <String, int>{};
    for (var i = 6; i >= 0; i--) {
      final key = df.format(now.subtract(Duration(days: i)));
      map[key] = 0;
    }
    for (var g in guests.where((g) => g.status == 'confirmed')) {
      final key = df.format(g.updatedAt);
      if (map.containsKey(key)) map[key] = (map[key] ?? 0) + 1;
    }

    final bars = map.entries.toList();
    final maxY =
        (bars
            .map((e) => e.value)
            .fold<int>(0, (a, b) => a > b ? a : b)).toDouble() +
        1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tendencia de confirmaciones (7 días)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.6,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= bars.length) {
                        return const SizedBox();
                      }
                      final date = DateTime.parse(bars[idx].key);
                      return Text(
                        DateFormat.E().format(date),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              barGroups:
                  bars.asMap().entries.map((e) {
                    final idx = e.key;
                    final val = e.value.value.toDouble();
                    return BarChartGroupData(
                      x: idx,
                      barRods: [
                        BarChartRodData(
                          toY: val,
                          color: Colors.blueAccent,
                          width: 10,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
