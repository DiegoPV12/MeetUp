// lib/widgets/event_details/status_badge.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';

class StatusBadge extends StatelessWidget {
  final bool isCancelled;
  const StatusBadge(this.isCancelled, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = isCancelled ? cs.errorContainer : cs.primaryContainer;
    final fg = isCancelled ? cs.onErrorContainer : cs.onPrimaryContainer;
    final text = isCancelled ? 'CANCELADO' : 'ACTIVO';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacingMedium,
        vertical: Spacing.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Spacing.spacingXLarge / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCancelled ? Icons.cancel_outlined : Icons.check_circle_outline,
            size: 18,
            color: fg,
          ),
          const SizedBox(width: Spacing.spacingSmall),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: fg,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
