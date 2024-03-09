import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconly/iconly.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class LikeButton extends HookWidget {
  final String recipeID;
  const LikeButton(this.recipeID, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      IconlyLight.heart,
      color: ExtraColors.darkGrey,
      size: 20,
    );
  }
}
