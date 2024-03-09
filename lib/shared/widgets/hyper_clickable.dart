import 'dart:async';

import 'package:flutter/material.dart';

import '../presentation/theme/extra_colors.dart';

class HyperClickable extends StatefulWidget {
  const HyperClickable({
    required this.child,
    required this.onClick,
    this.highlightColor,
    this.splashColor,
    super.key,
  });

  final GestureTapCallback onClick;

  final Color? highlightColor;
  final Color? splashColor;

  final Widget child;

  @override
  State<HyperClickable> createState() => _HyperClickableState();
}

class _HyperClickableState extends State<HyperClickable> {
  late var _isHyperActive = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 256), (_) {
      if (_isHyperActive) {
        widget.onClick();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: widget.highlightColor ?? ExtraColors.transparent,
      splashColor: widget.splashColor ?? ExtraColors.transparent,
      onTapCancel: () => _isHyperActive = false,
      onTapDown: (_) => _isHyperActive = true,
      onTapUp: (_) => _isHyperActive = false,
      child: widget.child,
    );
  }
}
