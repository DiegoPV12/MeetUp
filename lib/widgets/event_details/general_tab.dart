// lib/views/widgets/event_details/general_tab.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetup/widgets/event_details/info_row.dart';
import 'package:meetup/widgets/event_details/section_header.dart';
import 'package:meetup/theme/theme.dart';

class GeneralTab extends StatelessWidget {
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final String location;

  const GeneralTab({
    super.key,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateText = DateFormat('d MMMM yyyy', 'es_ES').format(startTime);
    final timeText =
        endTime != null
            ? '${DateFormat('HH:mm').format(startTime)} – ${DateFormat('HH:mm').format(endTime!)}'
            : DateFormat('HH:mm').format(startTime);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader('Detalles'),
          const SizedBox(height: Spacing.spacingSmall),

          // Fecha · Hora
          Row(
            children: [
              Expanded(
                child: InfoRow(
                  icon: Icon(Icons.calendar_today, color: cs.primary),
                  text: dateText.toUpperCase(),
                ),
              ),
              const SizedBox(width: Spacing.spacingMedium),
              Expanded(
                child: InfoRow(
                  icon: Icon(Icons.schedule, color: cs.primary),
                  text: timeText,
                ),
              ),
            ],
          ),

          const SizedBox(height: Spacing.spacingSmall),

          // Ubicación
          InfoRow(
            icon: Icon(Icons.location_on, color: cs.primary),
            text: location.toUpperCase(),
          ),

          const SizedBox(height: Spacing.spacingSmall),
          const Divider(),

          // Descripción
          const SectionHeader('Acerca'),
          const SizedBox(height: Spacing.spacingSmall),
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
