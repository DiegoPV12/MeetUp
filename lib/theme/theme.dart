import 'package:flutter/material.dart';

class FontSize {
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

class AppTheme {
  // Forzamos el primary exacto
  static const Color _seedColor = Color(0xFF6F2DBD);
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
  ).copyWith(primary: _seedColor);

  /// Light theme for the app
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    fontFamily: 'Noto Sans',
    textTheme: TextTheme(
      headlineLarge: const TextStyle(fontFamily: 'Coolvetica', fontSize: 42),
      headlineMedium: const TextStyle(fontFamily: 'Coolvetica'),
      headlineSmall: const TextStyle(fontFamily: 'Coolvetica'),
      titleLarge: const TextStyle(fontFamily: 'Coolvetica'),
      titleMedium: const TextStyle(fontFamily: 'Coolvetica'),
      titleSmall: const TextStyle(fontFamily: 'Coolvetica'),

      // Cuerpos con Noto Sans y tamaños definidos
      bodyLarge: const TextStyle(fontSize: FontSize.bodyLarge),
      bodyMedium: const TextStyle(fontSize: FontSize.bodyMedium),
      bodySmall: const TextStyle(fontSize: FontSize.bodySmall),
    ),

    // FilledButtons (primary actions)
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minimumSize: const Size(0, 56), // altura fija
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: FontSize.bodyLarge,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
    ),

    // OutlinedButtons (secondary actions)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _colorScheme.primary, width: 1.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        foregroundColor: _colorScheme.primary,
        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: FontSize.bodyLarge,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
    ),

    // Input fields (OutlinedTextFields)
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ), // aumento vertical
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _colorScheme.primary, width: 1.5),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade700),
      iconColor: Colors.grey.shade600,
      prefixIconColor: Colors.grey.shade600,
      suffixIconColor: Colors.grey.shade600,
    ),
  );
}

/// Global spacing constants (multiples of 8)
class Spacing {
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 40.0;

  /// Margen horizontal estándar
  static const double horizontalMargin = spacingLarge;

  /// Margen vertical estándar
  static const double verticalMargin = spacingMedium;
}
