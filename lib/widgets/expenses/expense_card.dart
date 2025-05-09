// lib/widgets/expenses/expense_card.dart
import 'package:flutter/material.dart';
import '../../models/expense_model.dart';
import '../../theme/theme.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: Spacing.spacingSmall),
      padding: const EdgeInsets.all(Spacing.spacingMedium),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar igual
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
          // Detalles ampliados
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
                  expense.description ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
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
          // Importe y acciones
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${expense.amount.toStringAsFixed(2)}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: cs.error),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: cs.primary),
                    onPressed: onEdit,
                    tooltip: 'Editar',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: cs.error),
                    onPressed: onDelete,
                    tooltip: 'Eliminar',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';
}
