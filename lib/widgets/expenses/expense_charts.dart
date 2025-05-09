// lib/widgets/expenses/expense_charts.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/expenses/bar_chart_expenses.dart';
import 'package:meetup/widgets/expenses/pie_chart.dart';
import '../../theme/theme.dart';
import '../../models/expense_model.dart';

class ExpenseCharts extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const ExpenseCharts({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── PieChart ───
          Center(
            child: Text(
              'Distribución por categoría',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: Spacing.spacingXLarge),
          ExpenseDistributionPieChart(expenses: expenses),

          const SizedBox(height: Spacing.spacingSmall),

          // ─── BarChart ───
          ExpenseCategoryBarChart(expenses: expenses),
        ],
      ),
    );
  }
}
