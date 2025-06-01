// lib/widgets/guests_overview/kpi_card.dart
import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: 180,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$value', style: tt.headlineMedium),
          const SizedBox(height: 4),
          Text(label, style: tt.labelLarge),
        ],
      ),
    );
  }
}
