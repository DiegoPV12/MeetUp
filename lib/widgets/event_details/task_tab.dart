// lib/views/widgets/event_detail/budget_tab.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/event_details/section_header.dart';

class TaskTab extends StatelessWidget {
  String eventId;
  TaskTab(this.eventId, {super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader('Lista de Tareas'),
          const SizedBox(height: Spacing.spacingLarge),
          const SizedBox(height: Spacing.spacingXLarge),
          FilledButton(
            onPressed:
                () => Navigator.pushNamed(
                  context,
                  '/event-tasks',
                  arguments: eventId,
                ),
            child: const Text('Ver Lista de Tareas'),
          ),
        ],
      ),
    );
  }
}
