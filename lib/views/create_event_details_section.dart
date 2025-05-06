// lib/views/create_event/details_section.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';

class DetailsSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  const DetailsSection({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
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
            // Título de la sección
            Text('Detalles', style: tt.headlineMedium),

            // Subtítulo descriptivo (puedes ajustarlo a tu gusto)
            const SizedBox(height: Spacing.spacingSmall),
            Text(
              'Completa la información básica del evento.',
              style: tt.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
            ),

            const SizedBox(height: Spacing.spacingLarge),

            // Campos
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre del Evento'),
              validator: (v) => v?.isEmpty == true ? 'Obligatorio' : null,
            ),
            const SizedBox(height: Spacing.spacingMedium),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
              validator: (v) => v?.isEmpty == true ? 'Obligatorio' : null,
            ),
          ],
        ),
      ),
    );
  }
}
