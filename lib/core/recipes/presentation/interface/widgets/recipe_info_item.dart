import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class RecipeInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;

  const RecipeInfoItem({
    required this.icon,
    required this.text,
    super.key,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Icon(
              icon,
              color: iconColor ?? ExtraColors.white,
              size: 17,
            ),
          ),
          const SizedBox(width: 1),
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? ExtraColors.white,
                wordSpacing: -2.2,
                letterSpacing: 0,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
