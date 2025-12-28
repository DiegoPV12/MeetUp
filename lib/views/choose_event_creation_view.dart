// lib/views/choose_event_creation_view.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/home/action_card.dart';
import 'package:meetup/widgets/shared/back_button_styled.dart';

class ChooseEventCreationView extends StatelessWidget {
  const ChooseEventCreationView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.horizontalMargin,
            vertical: Spacing.verticalMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button con sombra
              const BackButtonStyled(),
              const SizedBox(height: Spacing.spacingXXLarge),

              // Título
              Text(
                '¿Cómo deseas crear tu evento?',
                style: tt.headlineLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: Spacing.spacingXXLarge),

              // Acción: Desde cero
              ActionCard(
                title: 'Crear desde cero',
                subtitle: 'Comienza con un lienzo\nen blanco',
                buttonLabel: 'Crear',
                onPressed: () => Navigator.pushNamed(context, '/create-event'),
                backgroundColor: cs.primaryContainer,
                imagePath: 'assets/images/scratch.png',
              ),

              const SizedBox(height: Spacing.spacingLarge),

              // Acción: Usar plantilla
              ActionCard(
                title: 'Usar plantilla',
                subtitle: 'Elige entre opciones\nprediseñadas',
                buttonLabel: 'Plantilla',
                onPressed:
                    () => Navigator.pushNamed(context, '/create-from-template'),
                backgroundColor: cs.tertiaryContainer,
                buttonColor: cs.onTertiaryFixed, // color de fondo del botón
                buttonTextColor: cs.onPrimary, // color del texto del botón
                imagePath: 'assets/images/template.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
