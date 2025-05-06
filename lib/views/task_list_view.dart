import 'package:flutter/material.dart';
import 'package:meetup/models/task_model.dart';
import 'package:meetup/widgets/tasks/task_tile.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/task_viewmodel.dart';

class TaskListView extends StatefulWidget {
  final String eventId;

  const TaskListView({super.key, required this.eventId});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showTaskFormSheet(
    BuildContext context,
    TaskViewModel vm, {
    TaskModel? existingTask,
  }) {
    final isEdit = existingTask != null;
    final titleController = TextEditingController(
      text: existingTask?.title ?? '',
    );
    final descriptionController = TextEditingController(
      text: existingTask?.description ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? 'Editar Tarea' : 'Nueva Tarea',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: Icon(isEdit ? Icons.save : Icons.check),
                    label: Text(isEdit ? 'Guardar Cambios' : 'Crear Tarea'),
                    onPressed: () async {
                      final title = titleController.text.trim();
                      final desc = descriptionController.text.trim();

                      if (title.isEmpty || desc.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Completa ambos campos'),
                          ),
                        );
                        return;
                      }

                      try {
                        if (isEdit) {
                          await vm.editTask(
                            existingTask!.id,
                            title,
                            desc,
                            widget.eventId,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tarea actualizada')),
                          );
                        } else {
                          await vm.addTask(widget.eventId, title, desc);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tarea creada')),
                          );
                        }
                        if (context.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEdit
                                  ? 'Error al actualizar tarea'
                                  : 'Error al crear tarea',
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel()..loadTasks(widget.eventId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checklist del Evento'),
          actions: [
            Consumer<TaskViewModel>(
              builder:
                  (_, vm, __) => IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showTaskFormSheet(context, vm),
                  ),
            ),
          ],
        ),
        body: Consumer<TaskViewModel>(
          builder: (context, vm, _) {
            return Column(
              children: [
                if (vm.isLoading) const LinearProgressIndicator(),
                Expanded(
                  child:
                      vm.tasks.isEmpty
                          ? const Center(child: Text('No hay tareas aún.'))
                          : ListView.builder(
                            itemCount: vm.tasks.length,
                            itemBuilder: (context, index) {
                              final task = vm.tasks[index];
                              return TaskTile(
                                task: task,
                                onStatusChange: (newStatus) async {
                                  await vm.setTaskStatus(task.id, newStatus);
                                },
                                onEdit:
                                    () => _showTaskFormSheet(
                                      context,
                                      vm,
                                      existingTask: task,
                                    ),
                                onDelete: () async {
                                  final deletedTask = task;
                                  final taskIndex = vm.tasks.indexOf(task);

                                  try {
                                    await vm.deleteTask(
                                      task.id,
                                      widget.eventId,
                                    );

                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Tarea eliminada'),
                                        action: SnackBarAction(
                                          label: 'Deshacer',
                                          onPressed: () async {
                                            try {
                                              final restoredTask = TaskModel(
                                                id: deletedTask.id,
                                                title: deletedTask.title,
                                                description:
                                                    deletedTask.description,
                                                status: deletedTask.status,
                                                eventId: deletedTask.eventId,
                                                assignedTo:
                                                    deletedTask.assignedTo,
                                              );
                                              vm.insertTaskAt(
                                                restoredTask,
                                                taskIndex,
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Tarea restaurada',
                                                  ),
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Error al restaurar tarea',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Error al eliminar tarea',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
