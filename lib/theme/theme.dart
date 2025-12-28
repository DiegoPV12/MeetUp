import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class FontSize {
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

class AppTheme {
  static const Color _seedColor = Color(0xFF6F2DBD);
  static final TextTheme _baseTextTheme = Typography.material2021().black;
  static final TextTheme _appTextTheme = _baseTextTheme
      .apply(fontFamily: 'Noto Sans')
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

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        iconColor: colorScheme.onSurfaceVariant,
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
      );

  /// Light theme for the app
  static final ThemeData lightTheme = FlexThemeData.light(
    seedColor: _seedColor,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 12,
    subThemesData: const FlexSubThemesData(
      filledButtonRadius: 12,
      outlinedButtonRadius: 12,
      inputDecoratorBorderType: FlexInputBorderType.none,
      inputDecoratorRadius: 12,
    ),
    textTheme: _appTextTheme,
    fontFamily: 'Noto Sans',
  ).copyWith(
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: FontSize.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: FontSize.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: _inputDecorationTheme(
      FlexThemeData.light(seedColor: _seedColor).colorScheme,
    ),
  );

  /// Dark theme for the app
  static final ThemeData darkTheme = FlexThemeData.dark(
    seedColor: _seedColor,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 16,
    subThemesData: const FlexSubThemesData(
      filledButtonRadius: 12,
      outlinedButtonRadius: 12,
      inputDecoratorBorderType: FlexInputBorderType.none,
      inputDecoratorRadius: 12,
    ),
    textTheme: _appTextTheme,
    fontFamily: 'Noto Sans',
  ).copyWith(
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: FontSize.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: FontSize.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: _inputDecorationTheme(
      FlexThemeData.dark(seedColor: _seedColor).colorScheme,
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
