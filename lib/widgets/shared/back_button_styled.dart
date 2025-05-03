// lib/views/widgets/event_detail/back_button_styled.dart
import 'package:flutter/material.dart';

class BackButtonStyled extends StatelessWidget {
  const BackButtonStyled({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.secondaryContainer,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: cs.onSecondaryContainer,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: cs.primary),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
