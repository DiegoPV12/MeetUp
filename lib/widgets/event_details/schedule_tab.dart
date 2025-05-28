import 'package:flutter/material.dart';
import 'package:meetup/widgets/event_details/section_header.dart';
import 'package:meetup/widgets/activities/activity_tile.dart';
import 'package:provider/provider.dart';
import '../../../models/activity_model.dart';
import '../../../theme/theme.dart';
import '../../../viewmodels/activity_viewmodel.dart';

class ScheduleTab extends StatelessWidget {
  final String eventId;
  const ScheduleTab(this.eventId, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActivityViewModel>(
      create: (_) => ActivityViewModel()..load(eventId),
      child: Consumer<ActivityViewModel>(
        builder: (ctx, vm, _) {
          final List<ActivityModel> sample = vm.activities.take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeader('Cronograma del evento'),
                const SizedBox(height: Spacing.spacingLarge),

                if (vm.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (sample.isEmpty)
                  Text(
                    'No hay actividades registradas',
                    style: Theme.of(ctx).textTheme.bodyMedium,
                  )
                else
                  Column(
                    children:
                        sample
                            .map(
                              (a) => ActivityTile(activity: a, readOnly: true),
                            )
                            .toList(),
                  ),

                const SizedBox(height: Spacing.spacingXLarge),
                FilledButton(
                  onPressed:
                      () => Navigator.pushNamed(
                        context,
                        '/schedule',
                        arguments: eventId,
                      ),
                  child: const Text('Ver cronograma completo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
