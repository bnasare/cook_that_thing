import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';
import 'package:recipe_hub/src/category/presentation/interface/pages/category_page.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
      {super.key, required this.category, required this.imagePath});

  final String category;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onClick: () {
        NavigationHelper.navigateTo(
            context, RecipeCategoryPage(category: category));
      },
      child: Container(
        width: 110,
        decoration: BoxDecoration(
            color: ExtraColors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: ExtraColors.grey, width: 1)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ExtraColors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Center(
              child: Text(
                category,
                style: TextStyle(
                  color: ExtraColors.white.withOpacity(0.8),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
