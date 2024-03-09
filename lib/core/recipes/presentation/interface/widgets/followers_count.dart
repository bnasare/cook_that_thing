import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class FollowersCount extends HookWidget {
  final String chefID;
  final Color? textColor;
  const FollowersCount({super.key, required this.chefID, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      '1 follower',
      style: TextStyle(color: textColor ?? ExtraColors.darkGrey, fontSize: 14),
    );
  }
}
