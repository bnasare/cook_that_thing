import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class RecipeInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const RecipeInfoItem({
    required this.icon,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: ExtraColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Icon(
                icon,
                color: ExtraColors.white,
                size: 17,
              ),
            ),
            const SizedBox(width: 1),
            Flexible(
              flex: 1,
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ExtraColors.white,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
