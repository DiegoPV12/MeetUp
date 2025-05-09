import 'package:flutter/material.dart';
import '../../models/expense_model.dart';
import '../../viewmodels/expense_viewmodel.dart';

void showExpenseFormBottomSheet(
  BuildContext context,
  ExpenseViewModel vm, {
  required String eventId,
  ExpenseModel? existingExpense,
}) {
  final isEdit = existingExpense != null;
  final nameCtrl = TextEditingController(text: existingExpense?.name ?? '');
  final amountCtrl = TextEditingController(
    text: existingExpense?.amount.toString() ?? '',
  );
  final descCtrl = TextEditingController(
    text: existingExpense?.description ?? '',
  );

  final categories = {
    'logistics': 'Logística',
    'food': 'Comida',
    'catering': 'Catering',
    'decoration': 'Decoración',
    'transport': 'Transporte',
    'marketing': 'Publicidad',
    'other': 'Otro',
  };

  String? selectedCategory = existingExpense?.category ?? categories.keys.first;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (ctx) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder:
                (context, setState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEdit ? 'Editar Gasto' : 'Nuevo Gasto',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          categories.entries
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(entry.value),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedCategory = value);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Monto',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save),
                        label: Text(isEdit ? 'Actualizar' : 'Guardar'),
                        onPressed: () async {
                          final name = nameCtrl.text.trim();
                          final amount = double.tryParse(
                            amountCtrl.text.trim(),
                          );

                          if (name.isEmpty ||
                              selectedCategory == null ||
                              amount == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Completa todos los campos obligatorios',
                                ),
                              ),
                            );
                            return;
                          }

                          try {
                            if (isEdit) {
                              await vm.editExpense(
                                eventId,
                                existingExpense.copyWith(
                                  name: name,
                                  amount: amount,
                                  category: selectedCategory!,
                                  description: descCtrl.text.trim(),
                                ),
                              );
                            } else {
                              await vm.addExpense(
                                eventId,
                                ExpenseModel(
                                  id: '',
                                  name: name,
                                  amount: amount,
                                  category: selectedCategory!,
                                  description: descCtrl.text.trim(),
                                  date: DateTime.now(),
                                  eventId: eventId,
                                ),
                              );
                            }
                            if (context.mounted) Navigator.pop(ctx);
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al guardar gasto'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
          ),
        ),
  );
}
