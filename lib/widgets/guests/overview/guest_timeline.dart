// lib/widgets/guests_overview/guest_timeline.dart

import 'package:flutter/material.dart';
import '../../../models/guest_model.dart';

class GuestTimeline extends StatelessWidget {
  final List<GuestModel> guests;
  const GuestTimeline({super.key, required this.guests});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    // ordena por updatedAt (o createdAt si no existe)
    final sorted = [...guests]..sort((a, b) {
      return b.updatedAt.compareTo(a.updatedAt);
    });

    final List<Widget> entries = [];
    for (var i = 0; i < sorted.length && i < 15; i++) {
      final g = sorted[i];
      final date = g.updatedAt;
      entries.add(
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          leading: const Icon(Icons.history, size: 36),
          title: Text(g.name, style: tt.bodyLarge),
          subtitle: Text(_fmt(date), style: tt.bodySmall),
        ),
      );
      if (i < sorted.length - 1 && i < 14) {
        entries.add(const Divider(indent: 20, endIndent: 20));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historial de interacciones', style: tt.titleLarge),
        const SizedBox(height: 12),
        ...entries,
      ],
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}  '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
