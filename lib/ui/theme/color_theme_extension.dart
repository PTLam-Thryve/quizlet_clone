import 'package:flutter/material.dart';

class ColorThemeExtension extends ThemeExtension<ColorThemeExtension> {
  ColorThemeExtension({
    required this.loadingOverlay,
    required this.success,
    required this.warning,
    required this.error,
  });

  final Color loadingOverlay;
  final Color success;
  final Color warning;
  final Color error;

  @override
  ColorThemeExtension copyWith({
    Color? loadingOverlay,
    Color? success,
    Color? warning,
    Color? error,
  }) =>
      ColorThemeExtension(
        loadingOverlay: loadingOverlay ?? this.loadingOverlay,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        error: error ?? this.error,
      );

  @override
  ColorThemeExtension lerp(
    ThemeExtension<ColorThemeExtension>? other,
    double t,
  ) {
    if (other is! ColorThemeExtension) return this;
    return ColorThemeExtension(
      loadingOverlay: Color.lerp(loadingOverlay, other.loadingOverlay, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}
