// lib/views/widgets/home/next_event_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetup/models/event_model.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/views/event_detail_view.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final String imagePath;
  final double? width; //
  final double? height; //

  const EventCard({
    super.key,
    required this.event,
    this.imagePath = 'assets/images/event_placeholder.png',
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final dayLabel = DateFormat('d').format(event.startTime);
    final monthLabel = DateFormat('MMM').format(event.startTime).toUpperCase();
    final timeLabel =
        event.endTime != null
            ? '${DateFormat('hh:mm a').format(event.startTime)} – ${DateFormat('hh:mm a').format(event.endTime!)}'
            : DateFormat('hh:mm a').format(event.startTime);

    Widget card = InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDetailView(eventId: event.id)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen + marcador
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    imagePath,
                    height: height ?? 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: Spacing.spacingSmall,
                  left: Spacing.spacingSmall,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          dayLabel,
                          style: tt.headlineSmall!.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          monthLabel,
                          style: tt.bodySmall!.copyWith(
                            color: cs.primary,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Detalles
            Padding(
              padding: const EdgeInsets.all(Spacing.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: tt.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Spacing.spacingSmall),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: cs.primary),
                      const SizedBox(width: 4),
                      Expanded(child: Text(timeLabel, style: tt.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: Spacing.spacingSmall),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: cs.primary),
                      const SizedBox(width: 4),
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

    // Si me pasaron un width lo aplico con SizedBox
    if (width != null) {
      return SizedBox(width: width, child: card);
    } else {
      return card;
    }
  }
}
