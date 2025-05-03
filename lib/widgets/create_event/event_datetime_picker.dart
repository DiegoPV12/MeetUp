import 'package:flutter/material.dart';

class EventDateTimePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Function(DateTime) onDatePicked;
  final Function(TimeOfDay) onStartTimePicked;
  final Function(TimeOfDay) onEndTimePicked;

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
    return Column(
      children: [
        _buildRow(
          label:
              selectedDate == null
                  ? 'No has seleccionado fecha'
                  : 'Fecha: ${selectedDate!.toLocal().toString().split(' ')[0]}',
          onPressed: () async {
            final now = DateTime.now();
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: now,
              lastDate: DateTime(now.year + 5),
            );
            if (pickedDate != null) onDatePicked(pickedDate);
          },
          icon: Icons.calendar_today,
          buttonLabel: 'Seleccionar fecha',
        ),
        const SizedBox(height: 16),
        _buildRow(
          label:
              startTime == null
                  ? 'No has seleccionado hora de inicio'
                  : 'Inicio: ${startTime!.format(context)}',
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) onStartTimePicked(picked);
          },
          icon: Icons.access_time,
          buttonLabel: 'Hora inicio',
        ),
        const SizedBox(height: 16),
        _buildRow(
          label:
              endTime == null
                  ? 'No has seleccionado hora de fin'
                  : 'Fin: ${endTime!.format(context)}',
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) onEndTimePicked(picked);
          },
          icon: Icons.access_time,
          buttonLabel: 'Hora fin',
        ),
      ],
    );
  }

  Widget _buildRow({
    required String label,
    required VoidCallback onPressed,
    required IconData icon,
    required String buttonLabel,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(buttonLabel),
        ),
      ],
    );
  }
}
