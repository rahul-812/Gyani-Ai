import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ColorScheme get _lightColorScheme => const ColorScheme.light(
    primary: Color(0xFF3C80EE),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE9EEF6),
    onPrimaryContainer: Color(0xFF001A4D),
    tertiary: Color(0xFF444746),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1B1C1D),
    onSurfaceVariant: Color(0xFF727676),
    surfaceContainer: Color(0xFFFFFFFF),
    outline: Color(0xFFD9D9D9),
    outlineVariant: Color(0xFFE9EAE9),
    error: Color(0xFFD2463F),
    errorContainer: Color(0xFFFFE9E7),
  );

  static ColorScheme get _darkColorScheme => const ColorScheme.dark(
    primary: Color(0xFF3C80EE),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF333537),
    onPrimaryContainer: Color(0xFFFFFFFF),
    tertiary: Color(0xFFC4C7C5),
    surface: Color(0xFF1B1C1D),
    onSurface: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFF9A9B9C),
    surfaceContainer: Color(0xFF282A2C),
    outline: Color(0xFF74777F),
    outlineVariant: Color(0xFF3A3B3D),
    error: Color(0xFFA64D47),
    errorContainer: Color(0xFF3A221F),
  );

  static ThemeData get light => theme(_lightColorScheme);
  static ThemeData get dark => theme(_darkColorScheme);

  static ThemeData theme(ColorScheme colorScheme) {
    final baseBodyLargeTextTheme = const TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      // height: 1.5,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      scaffoldBackgroundColor: colorScheme.surface,

      // Appbar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorScheme.surface,
          statusBarIconBrightness: colorScheme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor: colorScheme.surfaceContainer,
          systemNavigationBarIconBrightness:
              colorScheme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        titleLarge: const TextStyle(
          fontFamily: 'Google Sans',
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        bodyLarge: baseBodyLargeTextTheme,
        bodyMedium: const TextStyle(fontFamily: 'Inter'),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(color: colorScheme.tertiary),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationThemeData(
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintFadeDuration: const Duration(milliseconds: 600),
        hintStyle: baseBodyLargeTextTheme.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
