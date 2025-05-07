import 'package:flutter/material.dart';
import 'package:meetup/models/task_model.dart';
import 'package:meetup/widgets/tasks/task_tile.dart';

/// Wrapper que convierte un `TaskTile` en elemento arrastrable.
/// Mantiene el botón de **editar** cuando no se está arrastrando.
class TaskTileDraggable extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onEdit; // ← NUEVO

  const TaskTileDraggable({super.key, required this.task, this.onEdit});

  static const _delay = Duration(
    milliseconds:
        150, // ⇠ ajusta aquí la latencia antes de iniciar el drag (snappy)
  );

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<TaskModel>(
      data: task,
      delay: _delay,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: TaskTile(task: task, readOnly: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: .3,
        child: TaskTile(task: task, readOnly: true),
      ),
      child: TaskTile(
        task: task,
        onEdit: onEdit, // ← mantiene el icono
      ),
    );
  }
}
