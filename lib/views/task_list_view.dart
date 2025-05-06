// lib/views/task_board_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task_model.dart';
import '../../theme/theme.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../widgets/tasks/task_tile.dart';

class TaskBoardView extends StatefulWidget {
  final String eventId;
  const TaskBoardView({super.key, required this.eventId});

  @override
  State<TaskBoardView> createState() => _TaskBoardViewState();
}

class _TaskBoardViewState extends State<TaskBoardView> {
  /* ─────────────── hoja modal NUEVA / EDITAR ─────────────── */
  void _openTaskSheet(
    BuildContext context,
    TaskViewModel vm, {
    TaskModel? task,
  }) {
    final isEdit = task != null;
    final titleCtrl = TextEditingController(text: task?.title);
    final descCtrl = TextEditingController(text: task?.description);

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
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(height: Spacing.spacingMedium),
                TextField(
                  controller: descCtrl,
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
                      final title = titleCtrl.text.trim();
                      final desc = descCtrl.text.trim();
                      if (title.isEmpty || desc.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Completa los campos')),
                        );
                        return;
                      }
                      try {
                        if (isEdit) {
                          await vm.editTask(
                            task!.id,
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

  /* ───────────────── helpers visuales ───────────────── */
  Widget _stageHeader(String text, Color color) => Container(
    height: 32,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: Spacing.spacingMedium),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel()..loadTasks(widget.eventId),
      child: Consumer<TaskViewModel>(
        builder: (ctx, vm, _) {
          final pending = vm.tasks.where((t) => t.status == 'pending').toList();
          final inProg =
              vm.tasks.where((t) => t.status == 'in_progress').toList();
          final done = vm.tasks.where((t) => t.status == 'completed').toList();

          final cs = Theme.of(ctx).colorScheme;

          /* ---------- un contenedor‑estado ---------- */
          Widget stage({
            required String label,
            required Color color,
            required List<TaskModel> tasks,
            required String newStatus,
          }) {
            return Expanded(
              child: DragTarget<TaskModel>(
                onWillAcceptWithDetails: (_) => true,
                onAcceptWithDetails:
                    (details) async =>
                        vm.setTaskStatus(details.data.id, newStatus),
                builder:
                    (c, _, __) => Container(
                      margin: const EdgeInsets.only(
                        bottom: Spacing.spacingMedium,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        children: [
                          _stageHeader(label, color),
                          const Divider(height: 1),
                          Expanded(
                            child:
                                tasks.isEmpty
                                    ? Center(
                                      child: Text(
                                        'Vacío',
                                        style: Theme.of(ctx)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: cs.outline),
                                      ),
                                    )
                                    : ListView.builder(
                                      padding: const EdgeInsets.all(
                                        Spacing.spacingSmall,
                                      ),
                                      itemCount: tasks.length,
                                      itemBuilder: (_, i) {
                                        final t = tasks[i];
                                        return LongPressDraggable<TaskModel>(
                                          data: t,
                                          feedback: Material(
                                            color: Colors.transparent,
                                            child: SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  .9,
                                              child: TaskTile(
                                                task: t,
                                                readOnly: true,
                                              ),
                                            ),
                                          ),
                                          childWhenDragging:
                                              const SizedBox.shrink(),
                                          child: TaskTile(
                                            task: t,
                                            onEdit:
                                                () => _openTaskSheet(
                                                  ctx,
                                                  vm,
                                                  task: t,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
                    ),
              ),
            );
          }

          /* ---------- papelera ---------- */
          final trash = DragTarget<TaskModel>(
            onWillAcceptWithDetails: (_) => true,
            onAcceptWithDetails:
                (details) async =>
                    vm.deleteTask(details.data.id, widget.eventId),
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

          /* ---------- Scafold ---------- */
          return Scaffold(
            appBar: AppBar(
              title: const Text('Checklist del evento'),
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
                          stage(
                            label: 'PENDIENTE',
                            color: cs.outline,
                            tasks: pending,
                            newStatus: 'pending',
                          ),
                          stage(
                            label: 'EN PROGRESO',
                            color: cs.secondary,
                            tasks: inProg,
                            newStatus: 'in_progress',
                          ),
                          stage(
                            label: 'COMPLETADO',
                            color: cs.tertiary,
                            tasks: done,
                            newStatus: 'completed',
                          ),
                          trash,
                        ],
                      ),
                    ),
          );
        },
      ),
    );
  }
}
