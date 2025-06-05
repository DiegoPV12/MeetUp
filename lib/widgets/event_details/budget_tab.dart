import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/event_detail_viewmodel.dart';
import '../../../viewmodels/expense_viewmodel.dart';
import '../../../models/edit_budget_arguments.dart';
import '../../../widgets/expenses/summary_header.dart';
import '../../../widgets/expenses/insight_chip.dart';
import '../../../widgets/expenses/expense_carousel.dart';
import '../../../theme/theme.dart';

class BudgetTab extends StatelessWidget {
  final String eventId;
  final DateTime eventStartDate;

  const BudgetTab({
    super.key,
    required this.eventId,
    required this.eventStartDate,
  });

  @override
  Widget build(BuildContext context) {
    // Escucho EventDetailViewModel para obtener el presupuesto más reciente
    final detailVm = Provider.of<EventDetailViewModel>(context);
    final b = detailVm.event?.budget ?? 0;

    return ChangeNotifierProvider(
      create: (_) => ExpenseViewModel()..loadExpenses(eventId),
      child: Consumer<ExpenseViewModel>(
        builder: (_, expVM, __) {
          final spent = expVM.expenses.fold<double>(0, (s, e) => s + e.amount);
          final pctUsed = b > 0 ? (spent / b).clamp(0.0, 2.0) : 0.0;
          final overspent = b > 0 && spent > b;
          final daysLeft = eventStartDate.difference(DateTime.now()).inDays;
          final pctLeft = (1 - pctUsed).clamp(0.0, 1.0);
          final recent = [...expVM.expenses]
            ..sort((a, b) => b.date.compareTo(a.date));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(
              Spacing.spacingLarge,
            ).copyWith(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SummaryHeader(
                  spent: spent,
                  budget: b,
                  pctUsed: pctUsed,
                  overspent: overspent,
                ),
                const SizedBox(height: Spacing.spacingLarge),
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
                if (recent.isNotEmpty) ...[
                  ExpenseCarousel(expenses: recent),
                  const SizedBox(height: Spacing.spacingXLarge),
                ],
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/budget',
                      arguments: EditBudgetArguments(
                        eventId: eventId,
                        currentBudget: b,
                      ),
                    ).then((dirty) {
                      if (dirty == true) {
                        detailVm.fetchEventDetail(eventId, false);
                      }
                    });
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
