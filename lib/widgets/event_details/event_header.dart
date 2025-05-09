// lib/views/widgets/event_detail/event_header.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/shared/back_button_styled.dart';
import 'package:meetup/theme/theme.dart';

class EventHeader extends StatelessWidget {
  final String imagePath;

  const EventHeader({super.key, required this.imagePath});

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
        // Oscurecer un poco
        Container(color: Colors.black26),
        // Back button
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.spacingMedium),
            child: BackButtonStyled(),
          ),
        ),
      ],
    );
  }
}
