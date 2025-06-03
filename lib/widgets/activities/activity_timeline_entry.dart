// lib/widgets/activities/activity_timeline_entry.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/activity_model.dart';

class ActivityTimelineEntry extends StatelessWidget {
  const ActivityTimelineEntry({
    super.key,
    required this.activity,
    this.readOnly = false,
    this.onEdit,
    this.onDelete,
  });

  final ActivityModel activity;
  final bool readOnly;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  String _fmt(DateTime d) => DateFormat('HH:mm').format(d);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HORARIO
          Text(
            '${_fmt(activity.startTime)} — ${_fmt(activity.endTime)}',
            style: tt.titleMedium!.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          // TÍTULO (más grande)
          Text(
            activity.name,
            style: tt.titleLarge!.copyWith(fontWeight: FontWeight.w500),
          ),

          // DESCRIPCIÓN
          if (activity.description.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(activity.description, style: tt.bodyLarge),
            ),

          // UBICACIÓN
          if (activity.location.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(Icons.place, size: 18, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      activity.location,
                      style: tt.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          // ACCIONES (solo iconos)
          if (!readOnly) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  tooltip: 'Editar',
                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: onEdit,
                ),
                IconButton(
                  tooltip: 'Eliminar',
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
