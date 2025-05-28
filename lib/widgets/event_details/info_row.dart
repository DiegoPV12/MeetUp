import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';

class InfoRow extends StatelessWidget {
  final Widget icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.spacingSmall),
      child: Row(
        children: [
          CircleAvatar(
            radius: Spacing.spacingMedium, // 16
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            child: icon,
          ),
          const SizedBox(width: Spacing.spacingMedium),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
