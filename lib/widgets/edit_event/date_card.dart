// lib/widgets/create_event/date_time_card.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';

class DateTimeCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const DateTimeCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(Spacing.spacingSmall), // 8 dp
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon container de 40x40 dp
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: cs.onPrimary, size: 24),
            ),

            const SizedBox(width: Spacing.spacingMedium), // 16 dp
            // Textos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tt.titleLarge, // MD3 titleMedium
                ),
                const SizedBox(height: Spacing.spacingXSmall), // 4 dp
                Text(
                  value,
                  style: tt.bodyLarge, // MD3 bodyMedium
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
