// lib/widgets/event_details/budget/summary_header.dart
import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class SummaryHeader extends StatelessWidget {
  final double spent;
  final double budget;
  final double pctUsed; // 0-2 (p.e. 1.2 => 120 %)
  final bool overspent;

  const SummaryHeader({
    super.key,
    required this.spent,
    required this.budget,
    required this.pctUsed,
    required this.overspent,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Color barColor() {
      if (pctUsed > 1) return cs.error;
      if (pctUsed > .65) return Colors.orange;
      return Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '\$${spent.toStringAsFixed(0)} '
          '/ \$${budget.toStringAsFixed(0)}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: Spacing.spacingMedium),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: budget == 0 ? 0 : pctUsed.clamp(0.0, 1.0),
            minHeight: 14,
            backgroundColor: cs.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(barColor()),
          ),
        ),
        if (overspent) ...[
          const SizedBox(height: Spacing.spacingSmall),
          Text(
            '¡Has excedido el presupuesto!',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: cs.error),
          ),
        ],
      ],
    );
  }
}
