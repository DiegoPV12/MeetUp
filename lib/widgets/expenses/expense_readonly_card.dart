// lib/widgets/expenses/expense_read_only_card.dart
import 'package:flutter/material.dart';
import '../../../models/expense_model.dart';
import '../../../theme/theme.dart';

class ExpenseReadOnlyCard extends StatelessWidget {
  final ExpenseModel expense;
  const ExpenseReadOnlyCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.spacingSmall),
      padding: const EdgeInsets.all(Spacing.spacingMedium),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar coherente
          CircleAvatar(
            radius: 24,
            backgroundColor: cs.primaryContainer,
            child: Text(
              expense.category.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: cs.onPrimaryContainer,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: Spacing.spacingMedium),
          // Detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(expense.date),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          // Importe
          Text(
            '\$${expense.amount.toStringAsFixed(0)}',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: cs.error),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';
}
