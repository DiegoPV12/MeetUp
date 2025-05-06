// lib/views/create_event/image_section.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/create_event/event_image_selector.dart';

class ImageSection extends StatelessWidget {
  final String? selectedImage;
  final ValueChanged<String?> onImageSelected;

  const ImageSection({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.horizontalMargin,
        vertical: Spacing.spacingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Imagen', style: tt.headlineMedium),
          const SizedBox(height: Spacing.spacingXSmall),
          Text(
            'Elige una imagen representativa para tu evento.',
            style: tt.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: Spacing.spacingLarge),
          EventImageSelector(
            selectedImage: selectedImage,
            onImageSelected: onImageSelected,
          ),
        ],
      ),
    );
  }
}
