import 'package:flutter/material.dart';
import 'package:meetup/models/task_model.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/tasks/task_tile_draggeable.dart';

class TaskColumn extends StatefulWidget {
  final String status; // pending | in_progress | completed
  final Color bg; // color de fondo pastel
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onAccept; // cambia estado en VM
  final ValueChanged<TaskModel>? onEdit; // ← NUEVO

  const TaskColumn({
    super.key,
    required this.status,
    required this.bg,
    required this.tasks,
    required this.onAccept,
    this.onEdit,
  });

  @override
  State<TaskColumn> createState() => _TaskColumnState();
}

class _TaskColumnState extends State<TaskColumn> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<TaskModel>(
      onWillAcceptWithDetails: (_) {
        setState(() => _hovering = true);
        return true;
      },
      onAcceptWithDetails: (details) {
        setState(() => _hovering = false);
        widget.onAccept(details.data);
      },
      onLeave: (_) => setState(() => _hovering = false),
      builder:
          (ctx, _, __) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(Spacing.spacingMedium),
            margin: const EdgeInsets.symmetric(vertical: Spacing.spacingSmall),
            decoration: BoxDecoration(
              color:
                  _hovering
                      ? widget.bg.withValues(alpha: 0.7)
                      : widget.bg, // resaltado al hacer hover
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleForStatus(widget.status),
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: Spacing.spacingMedium),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      overscroll: false,
                    ),
                    child: ListView.separated(
                      itemCount: widget.tasks.length,
                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(height: Spacing.spacingSmall),
                      itemBuilder:
                          (_, i) => TaskTileDraggable(
                            task: widget.tasks[i],
                            onEdit:
                                widget.onEdit == null
                                    ? null
                                    : () => widget.onEdit!(widget.tasks[i]),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  String _titleForStatus(String s) => switch (s) {
    'completed' => 'COMPLETADO',
    'in_progress' => 'EN PROGRESO',
    _ => 'PENDIENTE',
  };
}
