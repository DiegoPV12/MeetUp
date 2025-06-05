import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

typedef NavTapCallback = void Function(int index);

class BottomNavBar extends StatelessWidget {
  /// Índice activo (0 = Home, 1 = Eventos)
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CurvedNavigationBar(
      index: currentIndex,
      height: 60,
      backgroundColor: cs.onPrimary,
      color: cs.primary,
      buttonBackgroundColor: cs.onPrimaryContainer,
      animationCurve: Curves.easeOutCubic,
      animationDuration: const Duration(milliseconds: 600),
      letIndexChange: (_) => true,
      items: <Widget>[
        Icon(Icons.home_outlined, size: 24, color: cs.onPrimary),
        Icon(Icons.event_outlined, size: 24, color: cs.onPrimary),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (ModalRoute.of(context)?.settings.name != '/home') {
              Navigator.pushReplacementNamed(context, '/home');
            }
            break;
          case 1:
            if (ModalRoute.of(context)?.settings.name != '/events') {
              Navigator.pushReplacementNamed(context, '/events');
            }
            break;
        }
      },
    );
  }
}
