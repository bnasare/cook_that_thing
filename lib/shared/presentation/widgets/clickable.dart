import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/extra_colors.dart';

class Clickable extends StatelessWidget {
  const Clickable({
    required this.child,
    required this.onClick,
    this.highlightColor,
    this.borderRadius,
    this.splashColor,
    super.key,
  });

  final GestureTapCallback onClick;

  final BorderRadius? borderRadius;

  final Color? highlightColor;
  final Color? splashColor;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      highlightColor: highlightColor ?? ExtraColors.transparent,
      splashColor: splashColor ?? ExtraColors.transparent,
      onTap: () {
        HapticFeedback.vibrate();
        onClick();
      },
      child: child,
    );
  }
}
