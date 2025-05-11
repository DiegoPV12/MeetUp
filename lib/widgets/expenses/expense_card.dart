// lib/widgets/expenses/expense_card.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';
import '../../models/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  final ExpenseModel expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  // --- helpers --------------------------------------------------------------

  static const _categories = {
    'logistics': 'Logística',
    'food': 'Comida',
    'catering': 'Banquete',
    'decoration': 'Decoración',
    'transport': 'Transporte',
    'marketing': 'Publicidad',
    'other': 'Otro',
  };

  String get _displayCategory =>
      _categories[expense.category] ?? expense.category;

  Color _amountColor(ColorScheme cs) =>
      expense.amount >= 0 ? cs.error : cs.primary;

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';

  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.spacingSmall),
      padding: const EdgeInsets.all(Spacing.spacingSmall),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit, // editar ➜ tap
        onLongPress: onDelete, // borrar ➜ long-press (con confirmación externa)
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // leading – círculo colorido
              CircleAvatar(
                radius: 18,
                backgroundColor: cs.primaryContainer,
                child: Text(
                  expense.category.substring(0, 1).toUpperCase(),
                  style: tt.labelLarge!.copyWith(
                    color: cs.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // texto (título, descripción, fecha)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // título + monto
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            expense.name,
                            style: tt.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // descripción truncada
                    if ((expense.description ?? '').isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              expense.description!,
                              style: tt.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${expense.amount.toStringAsFixed(0)}',
                            style: tt.bodyLarge!.copyWith(
                              color: _amountColor(cs),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                    // fecha + categoría
                    Text(
                      '${_formatDate(expense.date)}  ·  $_displayCategory',
                      style: tt.bodySmall!.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),

              // menú ︙
              PopupMenuButton<int>(
                tooltip: 'Más opciones',
                onSelected: (v) {
                  if (v == 0) onEdit();
                  if (v == 1) onDelete();
                },
                itemBuilder:
                    (ctx) => [
                      const PopupMenuItem(value: 0, child: Text('Editar')),
                      const PopupMenuItem(value: 1, child: Text('Eliminar')),
                    ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
