// lib/views/widgets/event_detail/status_banner.dart

import 'package:flutter/material.dart';

/// Banner diagonal que indica "Cancelado" o "Activo"
class StatusBanner extends StatelessWidget {
  final bool isCancelled;
  const StatusBanner(this.isCancelled, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Colores según estado
    final bg = isCancelled ? cs.errorContainer : cs.primaryContainer;
    final fg = isCancelled ? cs.onErrorContainer : cs.onPrimaryContainer;
    final text = isCancelled ? 'CANCELADO' : 'ACTIVO';

    return Positioned(
      top: 16,
      left: -40,
      child: Transform.rotate(
        angle: -0.5, // rotar ligeramente
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: fg,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
