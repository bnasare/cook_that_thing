import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/clickable.dart';
import '../../../../../src/profile/presentation/interface/pages/profile.dart';
import '../../../domain/entities/recipe.dart';
import '../pages/recipe_details.dart';
import 'like_button.dart';
import 'recipe_info_item.dart';
import 'review_button.dart';

class RecipeWidget extends StatelessWidget {
  final List<Recipe> recipes;
  final int? itemCount;
  final Axis axis;
  final double? height;
  final double sizedBoxHeight;
  final double paddingTop;
  final double paddingBottom;
  final double? width;

  const RecipeWidget({
    super.key,
    required this.recipes,
    this.itemCount,
    this.sizedBoxHeight = 0,
    this.paddingTop = 20,
    this.paddingBottom = 20,
    this.width,
    this.axis = Axis.horizontal,
    this.height = 270,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.9;

    return SizedBox(
      width: width ?? screenWidth,
      height: height,
      child: ListView.separated(
        addSemanticIndexes: true,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) =>
            SizedBox(width: 20, height: sizedBoxHeight),
        padding: EdgeInsets.only(
            top: paddingTop, bottom: paddingBottom, left: 20, right: 20),
        shrinkWrap: true,
        scrollDirection: axis,
        itemBuilder: (context, index) {
          Recipe recipe = recipes[index];
          return Clickable(
            onClick: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return RecipeDetailsPage(recipeID: recipe.id);
                  },
                ),
              );
            },
            child: Container(
              width: width ?? screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: ExtraColors.darkGrey.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FancyShimmerImage(
                          imageUrl: recipe.image,
                          height: 230,
                          width: screenWidth,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ReviewButton(recipe.id),
                              LikeButton(recipe.id),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: ExtraColors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RecipeInfoItem(
                                    textColor: ExtraColors.grey,
                                    iconColor: ExtraColors.grey,
                                    icon: Icons.av_timer_outlined,
                                    text: recipe.duration,
                                    wordSpacing: -3,
                                    textSize: 17,
                                    iconSize: 20,
                                  ),
                                  const Text(
                                    '● ',
                                    style:
                                        TextStyle(color: ExtraColors.darkGrey),
                                  ),
                                  Text(
                                    recipe.difficultyLevel,
                                    style: const TextStyle(
                                      color: ExtraColors.grey,
                                      wordSpacing: -2.2,
                                      letterSpacing: 0,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const Text(
                                    ' ● ',
                                    style:
                                        TextStyle(color: ExtraColors.darkGrey),
                                  ),
                                  Flexible(
                                    child: Clickable(
                                      onClick: () => Navigator.of(context,
                                              rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return ProfilePage(
                                                chefID: recipe.chefID);
                                          },
                                        ),
                                      ),
                                      child: Text('by  ${recipe.chef}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: ExtraColors.grey,
                                            wordSpacing: -2.2,
                                            letterSpacing: 0,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: itemCount ?? recipes.length,
      ),
    );
  }
}
