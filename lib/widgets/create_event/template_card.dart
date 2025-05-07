// lib/widgets/create_event/template_card.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';

class TemplateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  /// Color de fondo de la tarjeta. Si es null, usa primaryContainer.
  final Color? backgroundColor;

  /// Color de la flecha de swipe. Si es null, usa primary.
  final Color? arrowColor;

  const TemplateCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    this.backgroundColor,
    this.arrowColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Si no se pasa backgroundColor, usamos primaryContainer
    final bg = backgroundColor ?? cs.primaryContainer;
    // Si no se pasa arrowColor, usamos primary
    final arrowCol = arrowColor ?? cs.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(Spacing.spacingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen grande y redondeada
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 180,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: Spacing.spacingLarge),
            Text(title, style: tt.headlineMedium),
            const SizedBox(height: Spacing.spacingSmall),
            Text(
              subtitle,
              style: tt.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.spacingMedium),
            Icon(Icons.arrow_forward, size: 28, color: arrowCol),
          ],
        ),
      ),
    );
  }
}
