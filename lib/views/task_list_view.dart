import 'package:flutter/material.dart';
import 'package:meetup/widgets/tasks/task_columns.dart';
import 'package:provider/provider.dart';

import '../../models/task_model.dart';
import '../../theme/theme.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../widgets/home/section_title.dart';

/* colores pastel “semáforo” */
const _yellowPastel = Color(0xFFFFF9C4); // PENDIENTE
const _bluePastel = Color(0xFFBBDEFB); // EN PROGRESO
const _greenPastel = Color(0xFFC8E6C9); // COMPLETADO

class TaskBoardView extends StatefulWidget {
  final String eventId;
  const TaskBoardView({super.key, required this.eventId});

  @override
  State<TaskBoardView> createState() => _TaskBoardViewState();
}

class _TaskBoardViewState extends State<TaskBoardView> {
  /* ─────────── hoja modal NUEVA / EDITAR ─────────── */
  void _openTaskSheet(
    BuildContext context,
    TaskViewModel vm, {
    TaskModel? task,
  }) {
    final isEdit = task != null;
    final tCtrl = TextEditingController(text: task?.title);
    final dCtrl = TextEditingController(text: task?.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              left: Spacing.spacingLarge,
              right: Spacing.spacingLarge,
              top: Spacing.spacingLarge,
              bottom:
                  MediaQuery.of(ctx).viewInsets.bottom + Spacing.spacingLarge,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? 'Editar tarea' : 'Nueva tarea',
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: Spacing.spacingLarge),
                TextField(
                  controller: tCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(height: Spacing.spacingMedium),
                TextField(
                  controller: dCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: Spacing.spacingLarge),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: Icon(isEdit ? Icons.save : Icons.check),
                    label: Text(isEdit ? 'Guardar' : 'Crear'),
                    onPressed: () async {
                      final title = tCtrl.text.trim();
                      final desc = dCtrl.text.trim();
                      if (title.isEmpty || desc.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Completa los campos')),
                        );
                        return;
                      }
                      try {
                        if (isEdit) {
                          await vm.editTask(
                            task.id,
                            title,
                            desc,
                            widget.eventId,
                          );
                        } else {
                          await vm.addTask(widget.eventId, title, desc);
                        }
                        if (mounted) Navigator.pop(ctx);
                      } catch (_) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEdit ? 'Error al actualizar' : 'Error al crear',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  /* ───────── diálogo de confirmación para papelera ───────── */
  Future<bool> _confirmDelete(BuildContext ctx) async {
    return await showDialog<bool>(
          context: ctx,
          builder:
              (_) => AlertDialog(
                title: const Text('Eliminar tarea'),
                content: const Text(
                  '¿Estás seguro de que deseas eliminar la tarea?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  /* ────────────────────────── build ────────────────────────── */
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel()..loadTasks(widget.eventId),
      child: Consumer<TaskViewModel>(
        builder: (ctx, vm, _) {
          /* separar por estado */
          final pending = vm.tasks.where((t) => t.status == 'pending').toList();
          final inProg =
              vm.tasks.where((t) => t.status == 'in_progress').toList();
          final done = vm.tasks.where((t) => t.status == 'completed').toList();

          /* papelera */
          Widget trash() {
            final cs = Theme.of(ctx).colorScheme;
            return DragTarget<TaskModel>(
              onWillAcceptWithDetails: (_) => true,
              onAcceptWithDetails: (details) async {
                final task = details.data;
                final original = task.status;
                vm.moveTaskOptimistic(task, '__trash__');
                final ok = await _confirmDelete(ctx);
                if (ok) {
                  await vm.deleteTask(task.id, widget.eventId);
                } else {
                  vm.revertTaskStatus(task, original);
                }
              },
              builder:
                  (_, __, ___) => Container(
                    height: 60,
                    margin: const EdgeInsets.only(top: Spacing.spacingMedium),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.delete,
                      color: cs.onErrorContainer,
                      size: 32,
                    ),
                  ),
            );
          }

          /* helper: crea una columna de tareas */
          Widget buildColumn({
            required String status,
            required Color bg,
            required List<TaskModel> tasks,
          }) {
            return Expanded(
              child: TaskColumn(
                status: status,
                bg: bg,
                tasks: tasks,
                onAccept: (task) {
                  vm.moveTaskOptimistic(task, status);
                  vm.setTaskStatus(task.id, status);
                },
                onEdit: (task) => _openTaskSheet(ctx, vm, task: task),
              ),
            );
          }

          /* Scaffold */
          return Scaffold(
            appBar: AppBar(
              title: const SectionTitle('Checklist del evento'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _openTaskSheet(ctx, vm),
                ),
              ],
            ),
            body:
                vm.isLoading
                    ? const LinearProgressIndicator()
                    : Padding(
                      padding: const EdgeInsets.all(Spacing.horizontalMargin),
                      child: Column(
                        children: [
                          buildColumn(
                            status: 'pending',
                            bg: _yellowPastel,
                            tasks: pending,
                          ),
                          buildColumn(
                            status: 'in_progress',
                            bg: _bluePastel,
                            tasks: inProg,
                          ),
                          buildColumn(
                            status: 'completed',
                            bg: _greenPastel,
                            tasks: done,
                          ),
                          trash(),
                        ],
                      ),
                    ),
          );
        },
      ),
    );
  }
}
