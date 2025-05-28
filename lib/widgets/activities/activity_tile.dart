import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/activity_model.dart';

class ActivityTile extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool readOnly;

  const ActivityTile({
    super.key,
    required this.activity,
    this.onDelete,
    this.onEdit,
    this.readOnly = false,
  });

  String _formatTimeRange(DateTime start, DateTime end) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return '${formatter.format(start)} – ${formatter.format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título + acciones
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.event_note_outlined, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    activity.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!readOnly) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                    tooltip: 'Editar',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Eliminar',
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Descripción
            Text(activity.description, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 12),

            // Horario y ubicación
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _formatTimeRange(activity.startTime, activity.endTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    activity.location ?? 'Sin ubicación',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
