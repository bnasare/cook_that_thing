import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../domain/entities/recipe.dart';
import '../../bloc/recipe_mixin.dart';
import 'like_button.dart';
import 'recipe_info_item.dart';

class RecipeInfo extends HookWidget with RecipeMixin {
  final Recipe recipe;
  final String recipeID;

  RecipeInfo({
    super.key,
    required this.recipe,
    required this.recipeID,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FancyShimmerImage(
            imageUrl: recipe.image,
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
                  recipe.title,
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
                    width: 1,
                    wordSpacing: -3,
                    textColor: ExtraColors.grey,
                    iconColor: ExtraColors.darkGrey,
                    icon: Icons.av_timer_outlined,
                    text: recipe.duration,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: RecipeInfoItem(
                      textSize: 17,
                      iconSize: 20,
                      width: 2.5,
                      textColor: ExtraColors.grey,
                      iconColor: ExtraColors.darkGrey,
                      icon: CupertinoIcons.person_alt_circle,
                      text: recipe.chef,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                    stream: getAverageReviewsRatingStreamm(recipe.id, context),
                    builder: (context, snapshot) {
                      return Material(
                        color: ExtraColors.yellow,
                        borderRadius: BorderRadius.circular(15),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 5),
                          child: RecipeInfoItem(
                            icon: Icons.grade,
                            textSize: 17,
                            iconSize: 20,
                            width: 2.5,
                            text: snapshot.data?.toStringAsFixed(1) ?? '0.0',
                            iconColor: ExtraColors.black,
                            textColor: ExtraColors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ExtraColors.lightGrey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: LikeButton(recipeID),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
