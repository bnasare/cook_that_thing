import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/review_button.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../pages/recipe_details.dart';
import 'recipe_info_item.dart';

class RecipeGridWidget extends StatelessWidget {
  // final List<Recipe> recipes;

  const RecipeGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.9,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        // Recipe recipe = recipes[index];
        return Clickable(
          onClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecipeDetailsPage(recipeID: ''),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FancyShimmerImage(
                        imageUrl:
                            'https://t4.ftcdn.net/jpg/02/84/46/89/360_F_284468940_1bg6BwgOfjCnE3W0wkMVMVqddJgtMynE.jpg',
                        width: double.infinity,
                        height: 110,
                      ),
                    ),
                    const Positioned(
                        top: 0,
                        right: 0,
                        // child: LikeButton(recipe.id),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.heart,
                              color: Colors.black,
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 3),
                const FittedBox(
                  child: Text(
                    'Fufu',
                    style: TextStyle(
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const FittedBox(
                  child: Text('By Benedict',
                      style: TextStyle(height: 0, fontSize: 15)),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(5),
                      color: ExtraColors.grey,
                      child: const RecipeInfoItem(
                        icon: Icons.av_timer_outlined,
                        text: '2 hrs',
                      ),
                    ),
                    const SizedBox(width: 5),
                    Material(
                      borderRadius: BorderRadius.circular(5),
                      color: ExtraColors.grey,
                      child: const RecipeInfoItem(
                        icon: IconlyLight.heart,
                        text: '3',
                      ),
                    ),
                    const SizedBox(width: 5),
                    const ReviewButton()
                  ],
                )
              ],
            ),
          ),
        );
      },
      itemCount: 6,
    );
  }
}
