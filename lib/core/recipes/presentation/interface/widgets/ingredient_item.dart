import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../shared/data/svg_assets.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';

class IngredientItem extends StatelessWidget {
  final String title;

  const IngredientItem({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            height: 24.0,
            width: 24.0,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ExtraColors.successLight.withOpacity(0.5),
            ),
            child: SvgPicture.asset(SvgAssets.check),
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: ExtraColors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
