import 'package:flutter/material.dart';
import 'package:meetup/models/edit_budget_arguments.dart';

class BudgetTab extends StatelessWidget {
  final double spent;
  final double budget;
  final String eventId;

  const BudgetTab({
    super.key,
    required this.spent,
    required this.budget,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final validBudget = budget > 0 ? budget : 1; // evita división por 0
    final percentage = spent / validBudget;
    final safePercentage =
        percentage.isFinite && !percentage.isNaN ? percentage : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '\$${spent.toInt()} / \$${budget.toInt()}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: safePercentage.clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.grey[300],
            color:
                safePercentage > 1.0
                    ? Colors.red
                    : (safePercentage > 0.75 ? Colors.orange : Colors.green),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/budget',
                arguments: EditBudgetArguments(
                  eventId: eventId,
                  currentBudget: budget,
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar Presupuesto'),
          ),
        ],
      ),
    );
  }
}
