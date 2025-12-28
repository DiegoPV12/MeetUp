// lib/widgets/create_event/event_datetime_picker.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';

class EventDateTimePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  final ValueChanged<DateTime> onDatePicked;
  final ValueChanged<TimeOfDay> onStartTimePicked;
  final ValueChanged<TimeOfDay> onEndTimePicked;

  const EventDateTimePicker({
    super.key,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.onDatePicked,
    required this.onStartTimePicked,
    required this.onEndTimePicked,
  });

  @override
  Widget build(BuildContext context) {
    /* --- utilidades --- */
    String dateLabel() {
      if (selectedDate == null) return 'Selecciona una fecha';
      final d = selectedDate!;
      return '${d.day}/${d.month}/${d.year}';
    }

    String timeLabel(TimeOfDay? t) => t?.format(context) ?? '--:--';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DateTimeField(
          label: 'Fecha',
          valueText: dateLabel(),
          icon: Icons.calendar_today,
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? now,
              firstDate: now,
              lastDate: DateTime(now.year + 5),
            );
            if (picked != null) onDatePicked(picked);
          },
        ),
        const SizedBox(height: Spacing.spacingMedium),
        Row(
          children: [
            Expanded(
              child: _DateTimeField(
                label: 'Hora inicio',
                valueText: timeLabel(startTime),
                icon: Icons.access_time,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: startTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) onStartTimePicked(picked);
                },
              ),
            ),
            const SizedBox(width: Spacing.spacingMedium),
            Expanded(
              child: _DateTimeField(
                label: 'Hora fin',
                valueText: timeLabel(endTime),
                icon: Icons.access_time,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: endTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) onEndTimePicked(picked);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/*------------------------------
| Widget auxiliar                                    
---------------------------*/
class _DateTimeField extends StatelessWidget {
  final String label;
  final String valueText;
  final IconData icon;
  final VoidCallback onTap;

  const _DateTimeField({
    required this.label,
    required this.valueText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        child: Text(
          valueText,
          style: tt.bodyLarge!.copyWith(
            color:
                (valueText.startsWith('Selecciona'))
                    ? cs.onSurfaceVariant
                    : cs.onSurface,
          ),
        ),
      ),
    );
  }
}
