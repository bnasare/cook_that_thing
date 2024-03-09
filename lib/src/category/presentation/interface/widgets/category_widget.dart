import 'package:flutter/material.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';
import 'package:recipe_hub/src/category/presentation/interface/pages/category_page.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onClick: () {
        NavigationHelper.navigateTo(
            context, RecipeCategoryPage(category: category));
      },
      child: Container(
        width: 90,
        decoration: BoxDecoration(
            color: ExtraColors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: ExtraColors.grey, width: 1)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
