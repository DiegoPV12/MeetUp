// lib/widgets/event_details/budget/budget_tab.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/expenses/expense_carousel.dart';
import 'package:meetup/widgets/expenses/insight_chip.dart';
import 'package:meetup/widgets/expenses/summary_header.dart';
import 'package:provider/provider.dart';
import '../../../models/edit_budget_arguments.dart';
import '../../../theme/theme.dart';
import '../../../viewmodels/expense_viewmodel.dart';

class BudgetTab extends StatelessWidget {
  final String eventId;
  final double? budget;
  final DateTime eventStartDate;

  const BudgetTab({
    super.key,
    required this.eventId,
    required this.budget,
    required this.eventStartDate,
  });

  @override
  Widget build(BuildContext context) {
    /// altura que ocupa el SpeedDial (≈ 76 px)
    const _fabSafeZone = 100.0;

    return ChangeNotifierProvider(
      create: (_) => ExpenseViewModel()..loadExpenses(eventId),
      child: Consumer<ExpenseViewModel>(
        builder: (_, expVM, __) {
          /* ─── métricas ─── */
          final spent = expVM.expenses.fold<double>(0, (s, e) => s + e.amount);
          final b = budget ?? 0;
          final pctUsed = b > 0 ? (spent / b).clamp(0.0, 2.0) : 0.0;
          final overspent = b > 0 && spent > b;

          final daysLeft = eventStartDate.difference(DateTime.now()).inDays;
          final pctLeft = (1 - pctUsed).clamp(0.0, 1.0);

          final recent = [...expVM.expenses]
            ..sort((a, b) => b.date.compareTo(a.date));

          /* ─── UI ─── */
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.spacingLarge).copyWith(
              bottom: _fabSafeZone, // evita que el botón tape el CTA
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 1 Resumen
                SummaryHeader(
                  spent: spent,
                  budget: b,
                  pctUsed: pctUsed,
                  overspent: overspent,
                ),
                const SizedBox(height: Spacing.spacingLarge),

                /// 2 Insight chips
                Wrap(
                  spacing: Spacing.spacingSmall,
                  runSpacing: Spacing.spacingSmall,
                  children: [
                    InsightChip(
                      icon: Icons.timelapse,
                      label:
                          daysLeft >= 0
                              ? 'Quedan $daysLeft días'
                              : 'Evento hoy',
                    ),
                    if (b > 0)
                      InsightChip(
                        icon: Icons.savings_outlined,
                        label: 'Libre: ${(pctLeft * 100).toStringAsFixed(0)} %',
                      ),
                    if (recent.isNotEmpty)
                      InsightChip(
                        icon: Icons.receipt_long_outlined,
                        label:
                            'Último \$${recent.first.amount.toStringAsFixed(0)}',
                      ),
                  ],
                ),
                const SizedBox(height: Spacing.spacingXLarge),

                /// 3 Carrusel de gastos recientes
                if (recent.isNotEmpty) ...[
                  ExpenseCarousel(expenses: recent),
                  const SizedBox(height: Spacing.spacingXLarge),
                ],

                /// 4 CTA
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/budget',
                      arguments: EditBudgetArguments(
                        eventId: eventId,
                        currentBudget: b,
                      ),
                    );
                  },
                  child: const Text('Ver presupuesto completo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
