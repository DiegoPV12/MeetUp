// lib/widgets/shared/app_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:meetup/theme/theme.dart';

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Tab> tabs;

  const AppTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ButtonsTabBar(
      backgroundColor: cs.primary,

      unselectedBackgroundColor: cs.surfaceContainerHighest,

      labelStyle: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(color: cs.onSurfaceVariant),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacingLarge,
      ),

      radius: 8,

      tabs: tabs,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
