import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/theme/color_theme_extension.dart';

void showAppSnackBar(
  BuildContext context, {
  required String message,
  required SnackBarStatus status,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: status.getColor(context),
    ),
  );
}

enum SnackBarStatus {
  success,
  warning,
  error,
}

extension ColorSnackBarStatusExt on SnackBarStatus {
  Color? getColor(BuildContext context) {
    switch (this) {
      case SnackBarStatus.success:
        return Theme.of(context).extension<ColorThemeExtension>()?.success;
      case SnackBarStatus.warning:
        return Theme.of(context).extension<ColorThemeExtension>()?.warning;
      case SnackBarStatus.error:
        return Theme.of(context).extension<ColorThemeExtension>()?.error;
    }
  }
}
