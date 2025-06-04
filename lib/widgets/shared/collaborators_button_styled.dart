import 'package:flutter/material.dart';

class CollaboratorsButtonStyled extends StatelessWidget {
  final String eventId;
  final String creatorId;

  const CollaboratorsButtonStyled({
    super.key,
    required this.eventId,
    required this.creatorId,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.secondaryContainer,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: cs.onSecondaryContainer,
      child: IconButton(
        icon: Icon(Icons.group, color: cs.primary),
        tooltip: 'Colaboradores',
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/collaborators',
            arguments: {'eventId': eventId, 'creatorId': creatorId},
          );
        },
      ),
    );
  }
}
