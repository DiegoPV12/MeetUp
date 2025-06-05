import 'package:flutter/material.dart';
import 'package:meetup/widgets/shared/dashed_border.dart';
import 'package:meetup/widgets/home/event_card.dart';
import 'package:meetup/models/event_model.dart';
import 'package:meetup/theme/theme.dart';

class EventSection extends StatelessWidget {
  final bool isLoading;
  final List<(EventModel, bool)> eventsWithFlag;
  const EventSection({
    required this.isLoading,
    required this.eventsWithFlag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (eventsWithFlag.isEmpty) {
      return DashedBorder(
        radius: 12,
        color: Theme.of(context).colorScheme.onTertiaryContainer,
        strokeWidth: 3,
        dashWidth: 6,
        dashGap: 6,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 180,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Text(
            'Aún no tienes eventos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        physics: const BouncingScrollPhysics(),
        padEnds: false,
        itemCount: eventsWithFlag.length,
        itemBuilder: (ctx, i) {
          final (event, isCollaborator) = eventsWithFlag[i];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacingMedium,
            ),
            child: EventCard(
              event: event,
              height: 140,
              isCollaborator: isCollaborator,
            ),
          );
        },
      ),
    );
  }
}
