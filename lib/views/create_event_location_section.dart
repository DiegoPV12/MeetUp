// lib/views/create_event/location_section.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/create_event/event_category_dropdown.dart';

class LocationSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController locationController;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const LocationSection({
    super.key,
    required this.formKey,
    required this.locationController,
    required this.selectedCategory,
    required this.onCategoryChanged,
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Ubicación', style: tt.headlineMedium),
            const SizedBox(height: Spacing.spacingXSmall),
            Text(
              'Indica dónde se realizará y su categoría.',
              style: tt.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: Spacing.spacingLarge),

            // Dirección
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Dirección'),
              validator: (v) => v?.isEmpty == true ? 'Obligatorio' : null,
            ),

            const SizedBox(height: Spacing.spacingMedium),

            // Categoría
            Text('Categoría', style: tt.titleMedium),
            const SizedBox(height: Spacing.spacingSmall),
            EventCategoryDropdown(
              selectedCategory: selectedCategory,
              onChanged: onCategoryChanged,
            ),
          ],
        ),
      ),
    );
  }
}
