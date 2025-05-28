import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/activity_model.dart';
import '../../viewmodels/activity_viewmodel.dart';

void showActivityFormBottomSheet(
  BuildContext context,
  ActivityViewModel vm, {
  required String eventId,
  ActivityModel? existing,
}) {
  final nameController = TextEditingController(text: existing?.name);
  final descController = TextEditingController(text: existing?.description);
  final locationController = TextEditingController(text: existing?.location);
  final startController = TextEditingController();
  final endController = TextEditingController();
  DateTime? start = existing?.startTime;
  DateTime? end = existing?.endTime;

  if (start != null) {
    startController.text = DateFormat('dd/MM/yyyy HH:mm').format(start);
  }
  if (end != null) {
    endController.text = DateFormat('dd/MM/yyyy HH:mm').format(end);
  }

  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (_) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  existing == null ? 'Nueva Actividad' : 'Editar Actividad',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Campo requerido'
                              : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Campo requerido'
                              : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Ubicación',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Campo requerido'
                              : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: startController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Hora de inicio',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.schedule),
                      onPressed: () async {
                        final picked = await showDateTimePicker(context, start);
                        if (picked != null) {
                          start = picked;
                          startController.text = DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(picked);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: endController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Hora de fin',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.schedule),
                      onPressed: () async {
                        final picked = await showDateTimePicker(context, end);
                        if (picked != null) {
                          end = picked;
                          endController.text = DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(picked);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    if (start == null || end == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Debes seleccionar hora de inicio y fin.',
                          ),
                        ),
                      );
                      return;
                    }

                    if (start!.isAfter(end!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'La hora de inicio debe ser anterior a la de fin.',
                          ),
                        ),
                      );
                      return;
                    }

                    final model = ActivityModel(
                      id: existing?.id ?? '',
                      name: nameController.text.trim(),
                      description: descController.text.trim(),
                      location: locationController.text.trim(),
                      startTime: start!,
                      endTime: end!,
                      eventId: eventId,
                    );

                    if (existing == null) {
                      vm.add(model);
                    } else {
                      vm.edit(model);
                    }

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
  );
}

Future<DateTime?> showDateTimePicker(
  BuildContext context,
  DateTime? initial,
) async {
  final fallback = DateTime.now();

  final date = await showDatePicker(
    context: context,
    initialDate: initial ?? fallback,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  if (date == null) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial ?? fallback),
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
