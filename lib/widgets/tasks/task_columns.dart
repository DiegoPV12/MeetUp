import 'package:flutter/material.dart';
import 'package:meetup/models/task_model.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/tasks/task_tile.dart';
import 'package:meetup/widgets/tasks/task_tile_draggeable.dart';

class TaskColumn extends StatefulWidget {
  /// pending • in_progress • completed
  final String status;
  final Color bg; // color pastel de la columna
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onAccept;
  final ValueChanged<TaskModel>? onEdit;

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

  // ───────────────────────── helpers ─────────────────────────
  String _titleForStatus(String s) => switch (s) {
    'completed' => 'COMPLETADO',
    'in_progress' => 'EN PROGRESO',
    _ => 'PENDIENTE',
  };

  /// Hoja modal que muestra **todas** las tareas de la columna
  void _openFullList(BuildContext context) {
    // -- ①  el color del contenedor que abrió el sheet
    final Color sheetColor = widget.bg; // p.e. pastel amarillo / azul / verde

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetColor, // -- ②  aplicarlo aquí
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => DraggableScrollableSheet(
            expand: false,
            maxChildSize: .9,
            minChildSize: .5,
            builder:
                (_, controller) => Padding(
                  padding: const EdgeInsets.all(Spacing.spacingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _titleForStatus(widget.status),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: Spacing.spacingMedium),
                      Expanded(
                        child: ListView.separated(
                          controller: controller,
                          itemCount: widget.tasks.length,
                          separatorBuilder:
                              (_, __) =>
                                  const SizedBox(height: Spacing.spacingSmall),
                          itemBuilder:
                              (_, i) => TaskTile(
                                task: widget.tasks[i],
                                readOnly: false,
                                onEdit:
                                    widget.onEdit == null
                                        ? null
                                        : () => widget.onEdit!(widget.tasks[i]),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  // ───────────────────────── build ─────────────────────────
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
                      ? widget.bg.withValues(alpha: 0xB3 /* ~70 % */)
                      : widget.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ───── encabezado (tap abre la vista completa) ─────
                GestureDetector(
                  onTap: () => _openFullList(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _titleForStatus(widget.status),
                          style: Theme.of(context).textTheme.titleLarge!,
                        ),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          widget.tasks.length.toString(),
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.spacingMedium),

                // ───── lista (drag-&-drop) ─────
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
}
