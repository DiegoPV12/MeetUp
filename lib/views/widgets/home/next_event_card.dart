import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetup/models/event_model.dart';
import 'package:meetup/theme/theme.dart';

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
        '${DateFormat('hh:mm a').format(event.startTime)} – ${DateFormat('hh:mm a').format(event.endTime)}';

    return Container(
      decoration: BoxDecoration(
        color: cs.onTertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(Spacing.spacingMedium),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
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
    );
  }
}
