import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';
import 'package:recipe_hub/core/review/presentation/interface/pages/view_reviews.dart';
import 'package:recipe_hub/shared/data/svg_assets.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../domain/entities/recipe.dart';
import '../widgets/ingredient_item.dart';
import '../widgets/recipe_detail_appbar.dart';

class RecipeDetailsPage extends HookWidget with RecipeMixin {
  final String recipeID;

  RecipeDetailsPage({super.key, required this.recipeID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: getRecipes(context: context, documentID: recipeID),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Loading',
                        style:
                            TextStyle(fontSize: 16.0, color: ExtraColors.grey)),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No recipes found'),
              );
            } else {
              List<Recipe> recipes = snapshot.data!;
              Recipe? recipe = recipes.firstWhere(
                  (recipe) => recipe.id == recipeID,
                  orElse: () => Recipe.initial());

              // ignore: unnecessary_null_comparison
              if (recipe == null) {
                // Handle the case where the recipe is null
                return const Center(child: Text('Recipe not found'));
              }

              return CustomScrollView(
                slivers: <Widget>[
                  RecipeDetailAppBar(imageUrl: recipe.image),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8.0),
                          DefaultTextStyle(
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: ExtraColors.grey),
                            child: Row(
                              children: [
                                Text(recipe.category),
                                const SizedBox(width: 8.0),
                                Container(
                                  height: 5.0,
                                  width: 5.0,
                                  decoration: const BoxDecoration(
                                    color: ExtraColors.darkGrey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(recipe.difficultyLevel),
                                const SizedBox(width: 8.0),
                                Container(
                                  height: 5.0,
                                  width: 5.0,
                                  decoration: const BoxDecoration(
                                    color: ExtraColors.darkGrey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(recipe.duration),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 32.0,
                                    width: 32.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ExtraColors.lightGrey,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 4),
                                          blurRadius: 4.0,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.person_alt_circle,
                                      color: ExtraColors.darkGrey,
                                      size: 45.0,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      recipe.chef,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 32.0,
                                    width: 32.0,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error
                                          .withOpacity(0.8),
                                    ),
                                    child: SvgPicture.asset(SvgAssets.heart),
                                  ),
                                  Text(
                                    recipe.likes.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: ExtraColors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          const Divider(
                              color: ExtraColors.lightGrey, thickness: 2),
                          const SizedBox(height: 16.0),
                          Text(
                            'Description',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            recipe.overview,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: ExtraColors.grey, fontSize: 16),
                          ),
                          const SizedBox(height: 16.0),
                          const Divider(
                              color: ExtraColors.lightGrey, thickness: 2),
                          const SizedBox(height: 16.0),
                          Text(
                            'Ingredients',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 16.0),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recipe.ingredients.length,
                              itemBuilder: (context, index) {
                                return IngredientItem(
                                    title: recipe.ingredients[index]);
                              }),
                          const Divider(
                              color: ExtraColors.lightGrey, thickness: 2),
                          const SizedBox(height: 16.0),
                          Text(
                            'Steps',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 16.0),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recipe.instructions.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 24.0,
                                        width: 24.0,
                                        alignment: Alignment.center,
                                        margin:
                                            const EdgeInsets.only(right: 16.0),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ExtraColors.darkBlue,
                                        ),
                                        child: Text(
                                          (index + 1).toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: ExtraColors.white,
                                                  fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          recipe.instructions[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: ExtraColors.grey,
                                                  fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            NavigationHelper.navigateTo(
                context, ViewReviewsPage(recipeID: recipeID));
          },
          label: const Text('Leave Review')),
    );
  }
}
