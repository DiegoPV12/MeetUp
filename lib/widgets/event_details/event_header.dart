import 'package:flutter/material.dart';
import 'package:meetup/widgets/shared/back_button_styled.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/widgets/shared/collaborators_button_styled.dart';

class EventHeader extends StatelessWidget {
  final String imagePath;
  final String eventId;
  final String creatorId;
  final bool isCollaborator;

  const EventHeader({
    super.key,
    required this.imagePath,
    required this.eventId,
    required this.creatorId,
    required this.isCollaborator,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          imagePath,
          height: 280,
          width: double.infinity,
          fit: BoxFit.fitHeight,
        ),
        // Capa semitransparente para oscurecer
        Container(color: Colors.black26),
        // Botones superiores
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.spacingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonStyled(),
                if (!isCollaborator)
                  CollaboratorsButtonStyled(
                    eventId: eventId,
                    creatorId: creatorId,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
