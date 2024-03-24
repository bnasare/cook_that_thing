import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recipe_hub/shared/data/image_assets.dart';
import 'package:recipe_hub/src/category/presentation/interface/widgets/category_widget.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CategoryWidget(
              imagePath: ImageAssets.breakfast,
              category: localizations.breakfast,
            ),
            const SizedBox(width: 15),
            CategoryWidget(
              imagePath: ImageAssets.lunch,
              category: localizations.lunch,
            ),
            const SizedBox(width: 15),
            CategoryWidget(
              imagePath: ImageAssets.dinner,
              category: localizations.dinner,
            ),
            const SizedBox(width: 15),
            CategoryWidget(
              imagePath: ImageAssets.dessert,
              category: localizations.dessert,
            ),
            const SizedBox(width: 15),
            CategoryWidget(
              imagePath: ImageAssets.snacks,
              category: localizations.snacks,
            ),
          ],
        ),
      ),
    );
  }
}
