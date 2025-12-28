import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../viewmodels/budget_viewmodel.dart';
import '../viewmodels/expense_viewmodel.dart';
import '../viewmodels/event_detail_viewmodel.dart';
import '../widgets/home/section_title.dart';
import '../widgets/expenses/summary_header.dart';
import '../widgets/expenses/expense_card.dart';
import '../widgets/expenses/expense_charts.dart';
import '../widgets/expenses/expense_form_bottom_sheet.dart';
import '../widgets/event_details/apptab.dart';

class EventBudgetView extends StatefulWidget {
  final String eventId;
  final double currentBudget;

  const EventBudgetView({
    super.key,
    required this.eventId,
    required this.currentBudget,
  });

  @override
  State<EventBudgetView> createState() => _EventBudgetViewState();
}

class _EventBudgetViewState extends State<EventBudgetView>
    with TickerProviderStateMixin {
  late final TabController _tabs;
  late final TextEditingController _budgetCtrl;
  double _budgetVal = 0;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _budgetVal = widget.currentBudget;
    _budgetCtrl = TextEditingController(text: _budgetVal.toStringAsFixed(0));
    _tabs = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveBudget(BuildContext ctx, BudgetViewModel vm) async {
    final val = double.tryParse(_budgetCtrl.text.trim());
    if (val == null || val < 0) {
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(const SnackBar(content: Text('Ingrese un monto válido')));
      return;
    }
    await vm.updateEventBudget(widget.eventId, val);
    if (!mounted) return;
    // Refrescar también los detalles del evento
    context.read<EventDetailViewModel>().fetchEventDetail(widget.eventId, false);
    if (!mounted) return;
    setState(() {
      _budgetVal = val;
      _dirty = true;
    });
    ScaffoldMessenger.of(
      ctx,
    ).showSnackBar(const SnackBar(content: Text('Presupuesto guardado')));
  }

  void _refresh() => setState(() => _dirty = true);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BudgetViewModel()),
          ChangeNotifierProvider(
            create: (_) => ExpenseViewModel()..loadExpenses(widget.eventId),
          ),
        ],
        child: Consumer2<BudgetViewModel, ExpenseViewModel>(
          builder: (_, budgetVM, expVM, __) {
            final spent = expVM.expenses.fold<double>(
              0,
              (sum, e) => sum + e.amount,
            );

            Widget generalTab() => SingleChildScrollView(
              padding: const EdgeInsets.all(
                Spacing.spacingLarge,
              ).copyWith(bottom: 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SummaryHeader(
                    spent: spent,
                    budget: _budgetVal,
                    pctUsed: _budgetVal == 0 ? 0 : spent / _budgetVal,
                    overspent: _budgetVal > 0 && spent > _budgetVal,
                  ),
                  const SizedBox(height: Spacing.spacingXLarge),
                  TextField(
                    controller: _budgetCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Presupuesto total',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: Spacing.spacingMedium),
                  FilledButton.icon(
                    onPressed: () => _saveBudget(context, budgetVM),
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                  const SizedBox(height: Spacing.spacingXLarge),
                  Text(
                    'Gastos',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: Spacing.spacingSmall),
                  expVM.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : expVM.expenses.isEmpty
                      ? const Center(child: Text('Sin gastos'))
                      : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: expVM.expenses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final e = expVM.expenses[i];
                          return ExpenseCard(
                            expense: e,
                            // ────────── EDITAR ──────────
                            onEdit: () {
                              // abre el formulario (devuelve void)
                              showExpenseFormBottomSheet(
                                context,
                                expVM,
                                eventId: widget.eventId,
                                existingExpense: e,
                              );

                              // refresca la lista optimistamente
                              _refresh();

                              // feedback visual
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Gasto actualizado'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.fixed,
                                  elevation: 4,
                                ),
                              );
                            },

                            // ────────── ELIMINAR ──────────
                            onDelete: () async {
                              final ok =
                                  await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (dCtx) => AlertDialog(
                                          title: const Text('Eliminar'),
                                          content: const Text(
                                            '¿Eliminar gasto?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    dCtx,
                                                    false,
                                                  ),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(dCtx, true),
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                  ) ??
                                  false;

                              if (ok) {
                                await expVM.deleteExpense(widget.eventId, e.id);
                                if (!mounted) return;
                                _refresh();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Gasto eliminado'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.fixed,
                                    elevation: 4,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                ],
              ),
            );

            Widget chartTab() => Padding(
              padding: const EdgeInsets.all(Spacing.spacingLarge),
              child: ExpenseCharts(expenses: expVM.expenses),
            );

            return Scaffold(
              appBar: AppBar(
                title: const SectionTitle('Presupuesto'),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: AppTabBar(
                    controller: _tabs,
                    tabs: const [
                      Tab(icon: Icon(Icons.list_alt), text: 'General'),
                      Tab(icon: Icon(Icons.bar_chart), text: 'Gráficas'),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const BackButtonIcon(),
                  onPressed: () => Navigator.pop(context, _dirty),
                ),
              ),
              floatingActionButton:
                  _tabs.index == 0
                      ? FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () {
                          showExpenseFormBottomSheet(
                            context,
                            expVM,
                            eventId: widget.eventId,
                          );
                          _refresh();
                        },
                      )
                      : null,
              body: TabBarView(
                controller: _tabs,
                children: [generalTab(), chartTab()],
              ),
            );
          },
        ),
      ),
    );
  }
}
