import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetup/models/event_model.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/viewmodels/event_viewmodel.dart';
import 'package:provider/provider.dart';

class NextEventCard extends StatelessWidget {
  final EventModel event;
  final String imagePath;

  const NextEventCard({
    super.key,
    required this.event,
    this.imagePath = 'assets/images/event_placeholder.png',
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final dateLabel = DateFormat('EEEE, d MMM yyyy').format(event.startTime);
    final timeLabel =
        event.endTime != null
            ? '${DateFormat('hh:mm a').format(event.startTime)} – ${DateFormat('hh:mm a').format(event.endTime!)}'
            : DateFormat('hh:mm a').format(event.startTime);

    return InkWell(
      onTap: () async {
        final updated = await Navigator.pushNamed(
          context,
          '/event-detail',
          arguments: event.id,
        );

        if (updated == true && context.mounted) {
          Provider.of<EventViewModel>(context, listen: false).fetchEvents();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: cs.onTertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(Spacing.spacingMedium),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: Spacing.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: tt.bodySmall!.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: Spacing.spacingXSmall),
                  Text(event.name, style: tt.headlineSmall),
                  const SizedBox(height: Spacing.spacingSmall),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: cs.primary),
                      const SizedBox(height: Spacing.spacingXSmall),
                      Text(timeLabel, style: tt.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: Spacing.spacingSmall),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: cs.primary),
                      const SizedBox(height: Spacing.spacingXSmall),
                      Expanded(
                        child: Text(
                          event.location,
                          style: tt.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
