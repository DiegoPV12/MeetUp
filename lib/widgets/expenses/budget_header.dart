import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

/// Muestra   $gastado  /  $presupuesto   + barra de progreso.
/// Se puede reutilizar tanto en la pestaña compacta como en la pantalla completa.
class BudgetHeader extends StatelessWidget {
  final double spent;
  final double budget;

  const BudgetHeader({super.key, required this.spent, required this.budget});

  @override
  Widget build(BuildContext context) {
    final pct = budget > 0 ? (spent / budget).clamp(0.0, 2.0) : 0.0;
    final cs = Theme.of(context).colorScheme;

    Color barColor() {
      if (pct > 1.0) return cs.error;
      if (pct > .75) return cs.secondary;
      return cs.tertiary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '\$${spent.toInt()} / \$${budget.toInt()}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: Spacing.spacingMedium),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            minHeight: 14,
            value: pct > 2 ? 1 : pct,
            backgroundColor: cs.surfaceVariant,
            color: barColor(),
          ),
        ),
        if (pct > 1.0) ...[
          const SizedBox(height: Spacing.spacingSmall),
          Center(
            child: Text(
              'Presupuesto excedido',
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: cs.error),
            ),
          ),
        ],
      ],
    );
  }
}
