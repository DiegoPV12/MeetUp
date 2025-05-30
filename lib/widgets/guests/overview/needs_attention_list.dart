// lib/widgets/guests_overview/needs_attention_list.dart

import 'package:flutter/material.dart';
import '../../../models/guest_model.dart';

class NeedsAttentionList extends StatelessWidget {
  final List<GuestModel> guests;
  final int pendingDays;
  const NeedsAttentionList({
    super.key,
    required this.guests,
    this.pendingDays = 3,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tt = Theme.of(context).textTheme;

    final items =
        guests.where((g) {
          final noInvite = !g.invitationSent;
          final tooLongPending =
              g.status == 'pending' &&
              now.difference(g.createdAt).inDays >= pendingDays;
          return noInvite || tooLongPending;
        }).toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Widget> tiles = [];
    for (var i = 0; i < items.length; i++) {
      final g = items[i];
      tiles.add(
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          leading: const Icon(Icons.warning_amber, color: Colors.red, size: 36),
          title: Text(g.name, style: tt.bodyLarge),
          subtitle: Text(
            !g.invitationSent
                ? 'Invitación no enviada'
                : 'Pendiente hace ≥ $pendingDays días',
            style: tt.bodySmall,
          ),
        ),
      );
      if (i < items.length - 1) {
        tiles.add(const Divider(indent: 20, endIndent: 20));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acción inmediata', style: tt.titleLarge),
        const SizedBox(height: 12),
        ...tiles,
      ],
    );
  }
}
