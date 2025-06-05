import 'package:flutter/material.dart';
import 'package:meetup/widgets/event_details/section_header.dart';
import 'package:meetup/widgets/tasks/task_tile.dart';
import 'package:provider/provider.dart';
import '../../../models/task_model.dart';
import '../../../theme/theme.dart';
import '../../../viewmodels/task_viewmodel.dart';

class TaskTab extends StatelessWidget {
  final String eventId;
  final String creatorId;
  const TaskTab({required this.eventId, required this.creatorId, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskViewModel>(
      create: (_) => TaskViewModel()..loadTasks(eventId),
      child: Consumer<TaskViewModel>(
        builder: (ctx, vm, _) {
          final List<TaskModel> sample = vm.tasks.take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeader('Lista de tareas'),
                const SizedBox(height: Spacing.spacingLarge),

                if (vm.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (sample.isEmpty)
                  Text(
                    'No hay tareas registradas',
                    style: Theme.of(ctx).textTheme.bodyMedium,
                  )
                else
                  Column(
                    children:
                        sample
                            .map((t) => TaskTile(task: t, readOnly: true))
                            .toList(),
                  ),

                const SizedBox(height: Spacing.spacingXLarge),
                FilledButton(
                  onPressed:
                      () => Navigator.pushNamed(
                        context,
                        '/event-tasks',
                        arguments: {'eventId': eventId, 'creatorId': creatorId},
                      ),
                  child: const Text('Ver lista completa'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
