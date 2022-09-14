import 'package:flutter/material.dart';

class DialogPage<T> extends Page<T> {
  const DialogPage({
    required this.child,
    this.themes,
    this.barrierLabel,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.useSafeArea = true,
  });

  final Widget child;
  final CapturedThemes? themes;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      settings: this,
      builder: (ctx) => child,
      themes: themes,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
    );
  }
}
