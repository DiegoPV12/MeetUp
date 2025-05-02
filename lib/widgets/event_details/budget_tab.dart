// lib/views/widgets/event_detail/budget_tab.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/event_details/section_header.dart';

class BudgetTab extends StatelessWidget {
  final double spent;
  final double budget;

  const BudgetTab({super.key, required this.spent, required this.budget});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader('Presupuesto'),
          const SizedBox(height: Spacing.spacingLarge),
          Center(
            child: Text(
              '\$${spent.toInt()} / \$${budget.toInt()}',
              style: tt.headlineSmall,
            ),
          ),
          const SizedBox(height: Spacing.spacingXLarge),
          LinearProgressIndicator(
            value: spent / budget,
            minHeight: Spacing.spacingSmall,
            color: cs.primary,
            backgroundColor: cs.secondaryContainer,
          ),
          const SizedBox(height: Spacing.spacingXLarge),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, '/budget'),
            child: const Text('Ver Desglose'),
          ),
          const SizedBox(height: Spacing.spacingMedium),
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/add-expense'),
            child: const Text('Agregar Gasto'),
          ),
        ],
      ),
    );
  }
}
