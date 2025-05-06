// lib/views/widgets/home/action_card.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String imagePath;
  final double borderRadius;

  /// Nuevos parámetros para personalizar el botón
  final Color? buttonColor;
  final Color? buttonTextColor;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
    this.backgroundColor,
    this.imagePath = 'assets/images/event_placeholder.png',
    this.borderRadius = 16.0,
    this.buttonColor,
    this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bg = backgroundColor ?? cs.primaryContainer;

    const cardHeight = 180.0;
    const imageOffset = 40.0;

    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Contenido textual y botón
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.spacingMedium),
              child: Row(
                children: [
                  // Texto y botón
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: tt.headlineMedium),
                        const SizedBox(height: Spacing.spacingSmall),
                        Text(subtitle, style: tt.bodyMedium),
                        const Spacer(),
                        // Botón con estilo personalizable
                        SizedBox(
                          width: 100,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: buttonColor ?? cs.primary,
                              foregroundColor: buttonTextColor ?? cs.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: onPressed,
                            child: Text(buttonLabel),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Espacio para la imagen
                  const SizedBox(width: Spacing.spacingMedium + imageOffset),
                ],
              ),
            ),
          ),

          // Imagen en posición flotante
          Positioned(
            right: Spacing.spacingMedium - imageOffset + 25,
            top: (cardHeight - 120) / 1.5,
            child: Image.asset(
              imagePath,
              width: 150,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
