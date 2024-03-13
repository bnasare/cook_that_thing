import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/review_button.dart';
import 'package:recipe_hub/shared/data/collection_ids.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';
import 'package:recipe_hub/src/profile/presentation/interface/pages/profile.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../domain/entities/recipe.dart';
import '../pages/recipe_details.dart';
import 'like_button.dart';
import 'recipe_info_item.dart';

class RecipeGridWidget extends StatelessWidget {
  final List<Recipe> recipes;
  final int? itemCount;

  const RecipeGridWidget({super.key, required this.recipes, this.itemCount});

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
        Recipe recipe = recipes[index];
        return Clickable(
          onClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailsPage(recipeID: recipe.id),
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
                        imageUrl: recipe.image,
                        width: double.infinity,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LikeButton(recipe.id),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Clickable(
                  onClick: () => NavigationHelper.navigateTo(
                      context, ProfilePage(chefID: recipe.chefID)),
                  child: Text('By ${recipe.chef}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(height: 0, fontSize: 18)),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color: ExtraColors.grey,
                        child: RecipeInfoItem(
                          icon: Icons.av_timer_outlined,
                          text: recipe.duration,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(DatabaseCollections.recipes)
                            .doc(recipe.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          DocumentSnapshot? recipeDoc = snapshot.data;
                          List<dynamic> likes = recipeDoc?['likes'] ?? [];
                          return Material(
                            borderRadius: BorderRadius.circular(5),
                            color: ExtraColors.grey,
                            child: RecipeInfoItem(
                              icon: IconlyLight.heart,
                              text: likes.isNotEmpty
                                  ? likes.length.toString()
                                  : '0',
                            ),
                          );
                        }),
                    const SizedBox(width: 5),
                    ReviewButton(recipe.id),
                  ],
                )
              ],
            ),
          ),
        );
      },
      itemCount: itemCount ?? recipes.length,
    );
  }
}
