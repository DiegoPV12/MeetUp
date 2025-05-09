// lib/widgets/event_details/budget/insight_chip.dart
import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class InsightChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const InsightChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      backgroundColor: cs.surfaceContainerLowest,
      avatar: Icon(icon, size: 18, color: cs.primary),
      label: Text(label),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacingSmall,
        vertical: Spacing.spacingXSmall,
      ),
    );
  }
}
