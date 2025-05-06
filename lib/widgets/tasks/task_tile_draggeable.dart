// lib/widgets/tasks/task_tile_draggable.dart
import 'package:flutter/material.dart';
import 'package:meetup/models/task_model.dart';
import 'package:meetup/widgets/tasks/task_tile.dart';

class TaskTileDraggable extends StatelessWidget {
  final TaskModel task;
  const TaskTileDraggable({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<TaskModel>(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: TaskTile(
            task: task,
            readOnly: true, // feedback, sin botones
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: .3,
        child: TaskTile(task: task, readOnly: true),
      ),
      child: TaskTile(task: task),
    );
  }
}
