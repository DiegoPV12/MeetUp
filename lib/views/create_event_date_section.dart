// lib/views/create_event/datetime_section.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/create_event/event_datetime_picker.dart';

class DateTimeSection extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? startTime, endTime;
  final ValueChanged<DateTime?> onDatePicked;
  final ValueChanged<TimeOfDay?> onStartPicked;
  final ValueChanged<TimeOfDay?> onEndPicked;

  const DateTimeSection({
    super.key,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.onDatePicked,
    required this.onStartPicked,
    required this.onEndPicked,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.horizontalMargin,
        vertical: Spacing.spacingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Fecha y hora', style: tt.headlineMedium),
          const SizedBox(height: Spacing.spacingXSmall),
          Text(
            'Selecciona la fecha y la duración del evento.',
            style: tt.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: Spacing.spacingLarge),
          EventDateTimePicker(
            selectedDate: selectedDate,
            startTime: startTime,
            endTime: endTime,
            onDatePicked: onDatePicked,
            onStartTimePicked: onStartPicked,
            onEndTimePicked: onEndPicked,
          ),
        ],
      ),
    );
  }
}
