import 'package:flutter/material.dart';
import 'package:meetup/widgets/expenses/budget_header.dart';
import 'package:meetup/widgets/home/section_title.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../viewmodels/budget_viewmodel.dart';
import '../viewmodels/expense_viewmodel.dart';
import '../widgets/expenses/expense_card.dart';
import '../widgets/expenses/expense_form_bottom_sheet.dart';

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

class _EventBudgetViewState extends State<EventBudgetView> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: widget.currentBudget.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Guarda presupuesto y devuelve TRUE al `Navigator.pop` si fue ok.
  Future<void> _saveBudget(BuildContext ctx, BudgetViewModel vm) async {
    final raw = _ctrl.text.trim();
    final value = double.tryParse(raw);
    if (value == null || value < 0) {
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(const SnackBar(content: Text('Ingrese un monto válido')));
      return;
    }
    try {
      await vm.updateEventBudget(widget.eventId, value);
      if (!mounted) return;
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(const SnackBar(content: Text('Presupuesto guardado')));
      Navigator.pop(ctx, true); // <-- avisa al caller para refrescar
    } catch (_) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Error al guardar presupuesto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BudgetViewModel()),
        ChangeNotifierProvider(
          create: (_) => ExpenseViewModel()..loadExpenses(widget.eventId),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const SectionTitle('Presupuesto y gastos')),
        floatingActionButton: Consumer<ExpenseViewModel>(
          builder:
              (_, expVM, __) => FloatingActionButton(
                onPressed: () {
                  showExpenseFormBottomSheet(
                    context,
                    expVM,
                    eventId: widget.eventId,
                  );
                },
                child: const Icon(Icons.add),
              ),
        ),
        body: Consumer2<BudgetViewModel, ExpenseViewModel>(
          builder: (_, budgetVM, expVM, __) {
            final spent = expVM.expenses.fold<double>(
              0,
              (s, e) => s + e.amount,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(
                Spacing.spacingLarge,
              ).copyWith(bottom: 100), // scroll-safe
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// A. Cabezal resumen grande
                  BudgetHeader(spent: spent, budget: widget.currentBudget),
                  const SizedBox(height: Spacing.spacingXLarge),

                  /// A.2 Campo para cambiar presupuesto
                  TextField(
                    controller: _ctrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Presupuesto total',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: Spacing.spacingMedium),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar presupuesto'),
                      onPressed: () => _saveBudget(context, budgetVM),
                    ),
                  ),

                  const SizedBox(height: Spacing.spacingXLarge),
                  Text(
                    'Gastos',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: Spacing.spacingSmall),

                  /// C. Lista de gastos
                  expVM.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : expVM.expenses.isEmpty
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: Text('Sin gastos registrados'),
                        ),
                      )
                      : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: expVM.expenses.length,
                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(height: Spacing.spacingSmall),
                        itemBuilder: (_, i) {
                          final e = expVM.expenses[i];
                          return ExpenseCard(
                            expense: e,
                            onEdit:
                                () => showExpenseFormBottomSheet(
                                  context,
                                  expVM,
                                  eventId: widget.eventId,
                                  existingExpense: e,
                                ),
                            onDelete: () async {
                              final ok =
                                  await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (ctx) => AlertDialog(
                                          title: const Text('Eliminar gasto'),
                                          content: const Text(
                                            '¿Eliminar definitivamente?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(ctx, false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(ctx, true),
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                  ) ??
                                  false;
                              if (ok) {
                                await expVM.deleteExpense(widget.eventId, e.id);
                              }
                            },
                          );
                        },
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
