import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define base themes with proper font scaling
ThemeData buildLightTheme(double fontScale) {
  final baseTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: Colors.indigo,
    useMaterial3: true,
  );
  
  return baseTheme.copyWith(
    textTheme: _buildScaledTextTheme(baseTheme.textTheme, fontScale),
  );
}

ThemeData buildDarkTheme(double fontScale) {
  final baseTheme = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.indigo,
    useMaterial3: true,
  );
  
  return baseTheme.copyWith(
    textTheme: _buildScaledTextTheme(baseTheme.textTheme, fontScale),
  );
}

// Helper function to scale text theme properly
TextTheme _buildScaledTextTheme(TextTheme base, double scale) {
  return TextTheme(
    displayLarge: base.displayLarge?.copyWith(fontSize: (base.displayLarge?.fontSize ?? 57) * scale),
    displayMedium: base.displayMedium?.copyWith(fontSize: (base.displayMedium?.fontSize ?? 45) * scale),
    displaySmall: base.displaySmall?.copyWith(fontSize: (base.displaySmall?.fontSize ?? 36) * scale),
    headlineLarge: base.headlineLarge?.copyWith(fontSize: (base.headlineLarge?.fontSize ?? 32) * scale),
    headlineMedium: base.headlineMedium?.copyWith(fontSize: (base.headlineMedium?.fontSize ?? 28) * scale),
    headlineSmall: base.headlineSmall?.copyWith(fontSize: (base.headlineSmall?.fontSize ?? 24) * scale),
    titleLarge: base.titleLarge?.copyWith(fontSize: (base.titleLarge?.fontSize ?? 22) * scale),
    titleMedium: base.titleMedium?.copyWith(fontSize: (base.titleMedium?.fontSize ?? 16) * scale),
    titleSmall: base.titleSmall?.copyWith(fontSize: (base.titleSmall?.fontSize ?? 14) * scale),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: (base.bodyLarge?.fontSize ?? 16) * scale),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: (base.bodyMedium?.fontSize ?? 14) * scale),
    bodySmall: base.bodySmall?.copyWith(fontSize: (base.bodySmall?.fontSize ?? 12) * scale),
    labelLarge: base.labelLarge?.copyWith(fontSize: (base.labelLarge?.fontSize ?? 14) * scale),
    labelMedium: base.labelMedium?.copyWith(fontSize: (base.labelMedium?.fontSize ?? 12) * scale),
    labelSmall: base.labelSmall?.copyWith(fontSize: (base.labelSmall?.fontSize ?? 11) * scale),
  );
}

// --- Theme Notifier ---
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // false = light, true = dark
  void toggleTheme() => state = !state;
}

// --- Font Size Notifier ---
class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier() : super(1.0); // 1.0x = normal size

  void setFontScale(double scale) => state = scale;
}

// --- Providers ---
final themeModeProvider =
    StateNotifierProvider<ThemeNotifier, bool>((ref) => ThemeNotifier());

final fontScaleProvider =
    StateNotifierProvider<FontSizeNotifier, double>((ref) => FontSizeNotifier());

// --- Combined Theme Provider ---
final themeProvider = Provider<ThemeData>((ref) {
  final isDark = ref.watch(themeModeProvider);
  final fontScale = ref.watch(fontScaleProvider);
  return isDark ? buildDarkTheme(fontScale) : buildLightTheme(fontScale);
});