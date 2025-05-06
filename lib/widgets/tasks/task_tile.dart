import 'package:flutter/material.dart';
import '../../../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final Function(String newStatus) onStatusChange;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onStatusChange,
    required this.onDelete,
    required this.onEdit,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.timelapse;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'COMPLETADO';
      case 'in_progress':
        return 'EN PROGRESO';
      default:
        return 'PENDIENTE';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(task.status);
    final statusIcon = _getStatusIcon(task.status);
    final statusLabel = _getStatusLabel(task.status);

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final confirmed =
            await showDialog<bool>(
              context: context,
              builder:
                  (ctx) => AlertDialog(
                    title: const Text('Eliminar Tarea'),
                    content: const Text(
                      '¿Estás seguro de que quieres eliminar esta tarea?',
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
        if (confirmed) {
          onDelete(); // <- elimina la tarea de la lista
        }
        return false; // <- previene que el widget se elimine automáticamente
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Icon(statusIcon, color: statusColor, size: 30),
          title: Text(
            task.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estado: $statusLabel',
                style: TextStyle(color: statusColor),
              ),
              if (task.description != null && task.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    task.description!,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
            ],
          ),
          trailing: SizedBox(
            width: 96,
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sync),
                  tooltip: 'Cambiar estado',
                  onSelected: onStatusChange,
                  itemBuilder:
                      (context) => [
                        CheckedPopupMenuItem(
                          value: 'pending',
                          checked: task.status == 'pending',
                          child: const Text('PENDIENTE'),
                        ),
                        CheckedPopupMenuItem(
                          value: 'in_progress',
                          checked: task.status == 'in_progress',
                          child: const Text('EN PROGRESO'),
                        ),
                        CheckedPopupMenuItem(
                          value: 'completed',
                          checked: task.status == 'completed',
                          child: const Text('COMPLETADO'),
                        ),
                      ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                  tooltip: 'Editar tarea',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
