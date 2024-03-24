import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_hub/core/recipes/domain/entities/recipe.dart';
import 'package:recipe_hub/core/review/presentation/bloc/review_mixin.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import 'recipe_info_item.dart';

class RecipeInfo extends StatefulWidget with ReviewMixin {
  final Recipe recipe;
  final String recipeID;

  RecipeInfo({
    super.key,
    required this.recipe,
    required this.recipeID,
  });

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FancyShimmerImage(
            imageUrl: widget.recipe.image,
            height: 110,
            width: 110,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  widget.recipe.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RecipeInfoItem(
                    textSize: 17,
                    iconSize: 20,
                    width: 4,
                    textColor: ExtraColors.grey,
                    iconColor: ExtraColors.darkGrey,
                    icon: Icons.av_timer_outlined,
                    text: widget.recipe.duration,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: RecipeInfoItem(
                      textSize: 17,
                      iconSize: 20,
                      width: 4,
                      textColor: ExtraColors.grey,
                      iconColor: ExtraColors.darkGrey,
                      icon: CupertinoIcons.person_alt_circle_fill,
                      text: widget.recipe.chef,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              FutureBuilder(
                future:
                    widget.getAverageReviewsRating(widget.recipeID, context),
                builder: (context, snapshot) {
                  return RecipeInfoItem(
                    icon: Icons.grade,
                    textSize: 17,
                    iconSize: 20,
                    width: 4,
                    text: snapshot.data?.toStringAsFixed(1) ?? '0.0',
                    iconColor: ExtraColors.yellow,
                    textColor: ExtraColors.grey,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
