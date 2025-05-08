// widgets/expenses/expense_card.dart
import 'package:flutter/material.dart';
import '../../models/expense_model.dart';

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
    final displayCategory = _translateCategory(expense.category);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(expense.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$displayCategory - \$${expense.amount.toStringAsFixed(2)}'),
            if (expense.description != null && expense.description!.isNotEmpty)
              Text(expense.description!, style: const TextStyle(fontSize: 13)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }

  String _translateCategory(String category) {
    switch (category) {
      case 'logistics':
        return 'Logística';
      case 'food':
        return 'Comida';
      case 'decoration':
        return 'Decoración';
      case 'catering':
        return 'Catering';
      case 'music':
        return 'Música';
      default:
        return category;
    }
  }
}
