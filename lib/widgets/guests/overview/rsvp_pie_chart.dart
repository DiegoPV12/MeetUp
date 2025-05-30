// lib/widgets/guests_overview/rsvp_pie_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/guest_model.dart';

class RsvpPieChart extends StatelessWidget {
  final List<GuestModel> guests;
  const RsvpPieChart({super.key, required this.guests});

  @override
  Widget build(BuildContext context) {
    if (guests.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = guests.length.toDouble();
    final confirmed =
        guests.where((g) => g.status == 'confirmed').length.toDouble();
    final pending =
        guests.where((g) => g.status == 'pending').length.toDouble();
    final declined =
        guests.where((g) => g.status == 'declined').length.toDouble();

    final data = {
      'Confirmado': confirmed,
      'Pendiente': pending,
      'Rechazado': declined,
    }..removeWhere((_, v) => v == 0);

    final colors = {
      'Confirmado': Colors.green.shade400,
      'Pendiente': Colors.orange.shade400,
      'Rechazado': Colors.red.shade400,
    };

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 40,
          sectionsSpace: 4,
          sections:
              data.entries.map((e) {
                final pct = (e.value / total) * 100;
                return PieChartSectionData(
                  color: colors[e.key],
                  value: e.value,
                  title: '${pct.toStringAsFixed(0)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
