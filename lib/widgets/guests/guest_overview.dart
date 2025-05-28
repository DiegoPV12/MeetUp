import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/guest_viewmodel.dart';

class GuestOverview extends StatelessWidget {
  const GuestOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GuestViewModel>(context);
    if (vm.total == 0) return const SizedBox.shrink();

    final total = vm.total.toDouble();
    final confirmed = vm.confirmed.toDouble();
    final pending = vm.pending.toDouble();
    final declined = vm.declined.toDouble();
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420), // Compact width
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // prevents stretching
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de invitados',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProgressBarRow(
                    context,
                    label: 'Confirmados',
                    count: confirmed.toInt(),
                    ratio: confirmed / total,
                    color: theme.colorScheme.primary,
                  ),
                  _buildProgressBarRow(
                    context,
                    label: 'Pendientes',
                    count: pending.toInt(),
                    ratio: pending / total,
                    color: Colors.amber[700]!,
                  ),
                  _buildProgressBarRow(
                    context,
                    label: 'Rechazados',
                    count: declined.toInt(),
                    ratio: declined / total,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Divider(color: theme.colorScheme.outline.withOpacity(0.3)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total: ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${vm.total}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBarRow(
    BuildContext context, {
    required String label,
    required int count,
    required double ratio,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: theme.colorScheme.surfaceVariant,
                color: color,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$count', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
