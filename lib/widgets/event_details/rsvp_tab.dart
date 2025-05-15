// lib/views/widgets/event_detail/rsvp_tab.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/event_details/section_header.dart';
import 'package:meetup/theme/theme.dart';

class RsvpTab extends StatelessWidget {
  final int confirmed;
  final int total;
  final String eventId;

  const RsvpTab({
    super.key,
    required this.confirmed,
    required this.total,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader('RSVP'),
          const SizedBox(height: Spacing.spacingLarge),
          Center(
            child: Text(
              '$confirmed / $total confirmados',
              style: tt.headlineSmall,
            ),
          ),
          const SizedBox(height: Spacing.spacingXLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: Spacing.spacingMedium),
                child: CircleAvatar(
                  radius: Spacing.spacingLarge,
                  child: Text('U${i + 1}'),
                ),
              );
            })..add(
              Text(
                '+${total - confirmed}',
                style: tt.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.spacingXLarge),
          FilledButton(
            onPressed:
                () =>
                    Navigator.pushNamed(context, '/guests', arguments: eventId),
            child: const Text('Ver Invitados'),
          ),
        ],
      ),
    );
  }
}
