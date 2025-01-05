import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/theme/color_theme_extension.dart';

ThemeData getLightTheme() {
  final colorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  return ThemeData(
    primaryColor: colorScheme.primary,
    brightness: Brightness.light,
    dividerColor: Colors.white54,
    colorScheme: colorScheme,
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.all(12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      ColorThemeExtension(
        loadingOverlay: colorScheme.onSurface.withOpacity(0.6),
        success: Colors.green.withOpacity(0.8),
        warning: Colors.yellow.withOpacity(0.8),
        error: Colors.red.withOpacity(0.8),
      ),
    ],
  );
}
