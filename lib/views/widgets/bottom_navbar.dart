// lib/views/widgets/home/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

typedef NavTapCallback = void Function(int index);

class BottomNavBar extends StatelessWidget {
  /// Índice activo (0 = Home, 1 = Eventos, 2 = Crear, 3 = Notificaciones, 4 = Perfil)
  final int currentIndex;

  /// Llamado cuando se pulsa una pestaña
  final NavTapCallback onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CurvedNavigationBar(
      index: currentIndex,
      height: 60,
      backgroundColor: cs.onPrimary,
      color: cs.primary,
      buttonBackgroundColor: cs.onPrimaryContainer,
      items: <Widget>[
        Icon(Icons.home_outlined, size: 24, color: cs.onPrimary),
        Icon(Icons.event_outlined, size: 24, color: cs.onPrimary),
        Icon(Icons.notifications_outlined, size: 24, color: cs.onPrimary),
        Icon(Icons.person_outline, size: 24, color: cs.onPrimary),
      ],
      animationCurve: Curves.easeOutCubic,
      animationDuration: const Duration(milliseconds: 600),
      onTap: onTap,
      letIndexChange: (_) => true,
    );
  }
}
