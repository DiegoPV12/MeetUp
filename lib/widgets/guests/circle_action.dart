import 'package:flutter/material.dart';

class CircleAction extends StatelessWidget {
  final Color backgroundColor;

  final IconData icon;

  final Color iconColor;

  final VoidCallback onTap;

  const CircleAction({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
