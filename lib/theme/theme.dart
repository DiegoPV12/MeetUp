import 'package:flutter/material.dart';

class FontSize {
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

class AppTheme {
  static const Color _seedColor = Color(0xFF6F2DBD);
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
  );
  static final TextTheme _baseTextTheme = Typography.material2021().black;
  static final TextTheme _appTextTheme = _baseTextTheme
      .apply(
        fontFamily: 'Noto Sans',
        displayColor: _colorScheme.onSurface,
        bodyColor: _colorScheme.onSurface,
      )
      .copyWith(
        displayLarge:
            _baseTextTheme.displayLarge?.copyWith(fontFamily: 'Coolvetica'),
        displayMedium:
            _baseTextTheme.displayMedium?.copyWith(fontFamily: 'Coolvetica'),
        displaySmall:
            _baseTextTheme.displaySmall?.copyWith(fontFamily: 'Coolvetica'),
        headlineLarge:
            _baseTextTheme.headlineLarge?.copyWith(fontFamily: 'Coolvetica'),
        headlineMedium:
            _baseTextTheme.headlineMedium?.copyWith(fontFamily: 'Coolvetica'),
        headlineSmall:
            _baseTextTheme.headlineSmall?.copyWith(fontFamily: 'Coolvetica'),
        titleLarge:
            _baseTextTheme.titleLarge?.copyWith(fontFamily: 'Coolvetica'),
        titleMedium:
            _baseTextTheme.titleMedium?.copyWith(fontFamily: 'Coolvetica'),
        titleSmall:
            _baseTextTheme.titleSmall?.copyWith(fontFamily: 'Coolvetica'),
      );

  /// Light theme for the app
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    fontFamily: 'Noto Sans',
    textTheme: _appTextTheme,

    // FilledButtons (primary actions)
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _colorScheme.primary,
        foregroundColor: _colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: FontSize.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    ),

    // OutlinedButtons (secondary actions)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _colorScheme.outline, width: 1.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: _colorScheme.primary,
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: FontSize.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    ),

    // Input fields (OutlinedTextFields)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _colorScheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _colorScheme.outline, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _colorScheme.outline, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _colorScheme.primary, width: 2.0),
      ),
      labelStyle: TextStyle(color: _colorScheme.onSurfaceVariant),
      iconColor: _colorScheme.onSurfaceVariant,
      prefixIconColor: _colorScheme.onSurfaceVariant,
      suffixIconColor: _colorScheme.onSurfaceVariant,
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
