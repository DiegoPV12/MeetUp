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

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
    this.backgroundColor,
    this.imagePath = 'assets/images/event_placeholder.png',
    this.borderRadius = 16.0,
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
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.spacingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: tt.headlineMedium),
                        const SizedBox(height: Spacing.spacingSmall),
                        Text(subtitle, style: tt.bodyMedium),
                        const Spacer(),
                        SizedBox(
                          width: 100,
                          child: FilledButton(
                            onPressed: onPressed,
                            child: Text(buttonLabel),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.spacingMedium + imageOffset),
                ],
              ),
            ),
          ),

          Positioned(
            right: Spacing.spacingMedium - imageOffset + 20,
            top: (cardHeight - 120), // centra la imagen verticalmente
            child: Image.asset(
              imagePath,
              width: 180,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
