// lib/views/create_from_template_view.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/shared/back_button_styled.dart';
import 'package:meetup/widgets/create_event/template_card.dart';

class CreateFromTemplateView extends StatelessWidget {
  const CreateFromTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final templates = [
      {
        'title': 'Cumpleaños',
        'subtitle': '¡Celebración llena de confeti!',
        'imagePath': 'assets/images/birthday.png',
        'bgColor': cs.primaryContainer,
        'arrowColor': cs.onPrimaryContainer,
        'onTap': () {
          Navigator.pushNamed(context, '/create-event', arguments: 'birthday');
        },
      },
      {
        'title': 'Junte',
        'subtitle': 'Encuentro con amigos',
        'imagePath': 'assets/images/friends.png',
        'bgColor': cs.secondaryContainer,
        'arrowColor': cs.onSecondaryContainer,
        'onTap': () {
          Navigator.pushNamed(
            context,
            '/create-event',
            arguments: 'get-together',
          );
        },
      },
      {
        'title': 'Reunión Familiar',
        'subtitle': 'Momentos en familia',
        'imagePath': 'assets/images/family.png',
        'bgColor': cs.tertiaryContainer,
        'arrowColor': cs.onTertiaryContainer,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '✨ ¡La plantilla de Reunión Familiar estará disponible en la próxima actualización! ✨',
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 3),
            ),
          );
        },
      },
      {
        'title': 'Cena',
        'subtitle': 'Cena elegante',
        'imagePath': 'assets/images/friends.png',
        'bgColor': cs.errorContainer,
        'arrowColor': cs.onErrorContainer,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '✨ ¡La plantilla de Cena estará disponible en la próxima actualización! ✨',
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 3),
            ),
          );
        },
      },
    ];
    double carouselHeight = 386.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(Spacing.spacingMedium),
              child: Align(
                alignment: Alignment.centerLeft,
                child: BackButtonStyled(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.horizontalMargin,
              ),
              child: Text(
                'Elige una plantilla',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: Spacing.spacingXLarge),

            SizedBox(
              height: carouselHeight,
              child: CarouselSlider.builder(
                itemCount: templates.length,
                options: CarouselOptions(
                  height: carouselHeight,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8, // <--- menos ancho ocupado
                  enableInfiniteScroll: false,
                  padEnds: true,
                ),
                itemBuilder: (ctx, index, realIdx) {
                  final tpl = templates[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacingSmall,
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 4, // <--- forzamos proporción
                      child: TemplateCard(
                        title: tpl['title'] as String,
                        subtitle: tpl['subtitle'] as String,
                        imagePath: tpl['imagePath'] as String,
                        backgroundColor: tpl['bgColor'] as Color,
                        arrowColor: tpl['arrowColor'] as Color,
                        onTap: tpl['onTap'] as VoidCallback,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: Spacing.spacingLarge),
          ],
        ),
      ),
    );
  }
}
