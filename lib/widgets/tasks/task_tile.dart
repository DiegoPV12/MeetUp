// lib/widgets/tasks/task_tile.dart
import 'package:flutter/material.dart';
import 'package:meetup/models/task_model.dart';
import 'package:meetup/theme/theme.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  final VoidCallback? onEdit;

  ///  Uso exclusivo como feedback mientras se arrastra
  final bool readOnly;

  const TaskTile({
    super.key,
    required this.task,
    this.onEdit,
    required this.readOnly,
  });

  // ---------- helpers visuales ----------
  Color _statusColor(ColorScheme cs) {
    switch (task.status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blueAccent;
      default:
        return Colors.yellow.shade900;
    }
  }

  IconData _statusIcon() {
    switch (task.status) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.timelapse;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bg = cs.surfaceContainerHighest;
    final radius = BorderRadius.circular(12);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: Spacing.spacingSmall),
      decoration: BoxDecoration(color: bg, borderRadius: radius),
      padding: const EdgeInsets.all(Spacing.spacingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icono de estado
          Padding(
            padding: const EdgeInsets.only(top: Spacing.spacingXSmall),
            child: Icon(_statusIcon(), color: _statusColor(cs), size: 28),
          ),
          const SizedBox(width: Spacing.spacingMedium),
          // texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: tt.titleLarge),
                const SizedBox(height: Spacing.spacingXSmall),

                if (task.description.isNotEmpty) ...[
                  Text(task.description, style: tt.bodyMedium),
                  const SizedBox(height: Spacing.spacingXSmall),
                ],

                // Mostrar colaborador asignado si existe
                if (task.assignedUserName != null)
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        task.assignedUserName!,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (!readOnly)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar',
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
