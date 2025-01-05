import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/theme/color_theme_extension.dart';
import 'package:quizlet_clone/ui/widgets/app_progress_indicator.dart';

/// A widget that displays a loading overlay over its child widget.
///
/// The [LoadingOverlay] widget is a [StatelessWidget] that shows a loading
/// indicator over its child widget when [isLoading] is true. It also provides
/// an optional callback [onPopInvoked] that is called when the overlay is
/// dismissed if [canPop] is true.
class LoadingOverlay extends StatelessWidget {
  /// Creates a [LoadingOverlay] widget.
  ///
  /// The [child] and [isLoading] parameters are required.
  /// The [canPop] parameter defaults to false.
  const LoadingOverlay({
    required this.child,
    required this.isLoading,
    super.key,
    this.canPop = false,
    this.onPopInvoked,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Whether the loading overlay is visible.
  final bool isLoading;

  /// Whether the overlay can be dismissed.
  final bool canPop;

  /// Callback invoked when the overlay is dismissed.
  final PopInvokedWithResultCallback<void>? onPopInvoked;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: canPop,
        onPopInvokedWithResult: onPopInvoked,
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Stack(
            children: [
              child,
              if (isLoading)
                Container(
                  color: Theme.of(context)
                      .extension<ColorThemeExtension>()
                      ?.loadingOverlay,
                  child: const AppProgressIndicator(),
                ),
            ],
          ),
        ),
      );
}
