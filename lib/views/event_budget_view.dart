import 'package:flutter/material.dart';
import 'package:meetup/widgets/expenses/expense_card.dart';
import 'package:meetup/widgets/expenses/expense_form_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/budget_viewmodel.dart';
import '../../viewmodels/expense_viewmodel.dart';

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
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(
      text: widget.currentBudget.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
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
        appBar: AppBar(title: const Text('Presupuesto y Gastos')),
        floatingActionButton: Consumer<ExpenseViewModel>(
          builder:
              (context, vm, _) => FloatingActionButton(
                onPressed: () {
                  showExpenseFormBottomSheet(
                    context,
                    vm,
                    eventId: widget.eventId,
                  );
                },
                child: const Icon(Icons.add),
              ),
        ),
        body: Consumer2<BudgetViewModel, ExpenseViewModel>(
          builder: (context, budgetVM, expenseVM, _) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Presupuesto Total',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Presupuesto'),
                      onPressed: () async {
                        final input = _budgetController.text.trim();
                        final amount = double.tryParse(input);
                        if (amount == null || amount < 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ingrese un monto válido'),
                            ),
                          );
                          return;
                        }
                        try {
                          await budgetVM.updateEventBudget(
                            widget.eventId,
                            amount,
                          );
                          if (mounted) Navigator.pop(context, true);
                        } catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error al guardar el presupuesto'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const Text(
                    'Gastos del Evento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Total Gastado: \$${expenseVM.expenses.fold(0.0, (sum, e) => sum + e.amount).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        expenseVM.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : expenseVM.expenses.isEmpty
                            ? const Center(
                              child: Text('Sin gastos registrados'),
                            )
                            : ListView.builder(
                              itemCount: expenseVM.expenses.length,
                              itemBuilder: (ctx, index) {
                                final exp = expenseVM.expenses[index];

                                return ExpenseCard(
                                  expense: exp,
                                  onEdit:
                                      () => showExpenseFormBottomSheet(
                                        context,
                                        expenseVM,
                                        eventId: widget.eventId,
                                        existingExpense: exp,
                                      ),
                                  onDelete: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (ctx) => AlertDialog(
                                            title: const Text('Eliminar Gasto'),
                                            content: const Text(
                                              '¿Deseas eliminar este gasto?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      ctx,
                                                      false,
                                                    ),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      ctx,
                                                      true,
                                                    ),
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        await expenseVM.deleteExpense(
                                          widget.eventId,
                                          exp.id,
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Gasto eliminado'),
                                          ),
                                        );
                                      } catch (_) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Error al eliminar gasto',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                );
                              },
                            ),
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
