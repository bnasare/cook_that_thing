// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class FollowButton extends HookWidget {
  final String chefID;
  final double? height;
  final double? width;
  final double? fontSize;
  const FollowButton(this.height, this.width, this.fontSize,
      {super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 35,
      width: width ?? 75,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: ExtraColors.darkGrey),
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(
          'Unfollow',
          style: TextStyle(fontSize: fontSize ?? 13, color: ExtraColors.white),
        ),
      ),
    );
  }
}
