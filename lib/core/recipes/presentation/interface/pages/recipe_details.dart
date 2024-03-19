import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_info_item.dart';
import 'package:recipe_hub/core/review/presentation/interface/pages/view_reviews.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../domain/entities/recipe.dart';

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
              return SpinKitFadingCircle(
                color: Theme.of(context).colorScheme.primary,
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

              return Stack(
                children: [
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const SizedBox(
                            height: 300,
                            width: double.infinity,
                          ),
                          Positioned(
                            child: CachedNetworkImage(
                              imageUrl: recipe.image,
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const SizedBox(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: IconButton.filledTonal(
                                    icon: const Icon(CupertinoIcons.backward),
                                    onPressed: () =>
                                        NavigationHelper.navigateBack(context),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ExtraColors.white),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(20, 20)),
                                      iconSize: MaterialStateProperty.all(20),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              ExtraColors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: IconButton.filledTonal(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ExtraColors.white),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(20, 20)),
                                      iconSize: MaterialStateProperty.all(20),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              ExtraColors.black),
                                    ),
                                    icon: const Icon(IconlyLight.message),
                                    onPressed: () {
                                      NavigationHelper.navigateTo(context,
                                          ViewReviewsPage(recipeID: recipe.id));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      Expanded(
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              TabBar(
                                dividerHeight: 0,
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                labelStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                                unselectedLabelColor: ExtraColors.grey,
                                tabs: const [
                                  Tab(text: 'Overview'),
                                  Tab(text: 'Ingredients'),
                                  Tab(text: 'Directions'),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    ListView(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30, bottom: 10),
                                      shrinkWrap: true,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(recipe.overview),
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: const Text('Meal'),
                                          trailing: Text(recipe.category,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16)),
                                        ),
                                        Divider(
                                            color: ExtraColors.darkGrey
                                                .withOpacity(0.3)),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: const Text('Diet'),
                                          trailing: Text(recipe.diet,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16)),
                                        ),
                                        Divider(
                                            color: ExtraColors.darkGrey
                                                .withOpacity(0.3)),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: const Text('Cooking Time'),
                                          trailing: Text(recipe.duration,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16)),
                                        )
                                      ],
                                    ),
                                    ListView.separated(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30, bottom: 10),
                                      shrinkWrap: true,
                                      itemCount: recipe.ingredients.length,
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        color: ExtraColors.darkGrey
                                            .withOpacity(0.3),
                                      ),
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: Text(
                                            '${index + 1}.',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          title: Text(recipe.ingredients[index],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: ExtraColors.grey)),
                                        );
                                      },
                                    ),
                                    ListView.separated(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30, bottom: 10),
                                      shrinkWrap: true,
                                      itemCount: recipe.instructions.length,
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        color: ExtraColors.darkGrey
                                            .withOpacity(0.3),
                                      ),
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: Text(
                                            '${index + 1}.',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          title: Text(
                                              recipe.instructions[index],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: ExtraColors.grey)),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.323,
                    right: 0,
                    left: 0,
                    height: 130,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: ExtraColors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                              blurRadius: 6.0),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            recipe.title,
                            style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                height: 0),
                          ),
                          Divider(color: ExtraColors.darkGrey.withOpacity(0.3)),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RecipeInfoItem(
                                    icon: Icons.auto_graph_outlined,
                                    text: recipe.difficultyLevel,
                                    iconColor: ExtraColors.grey,
                                    textColor: ExtraColors.black),
                                RecipeInfoItem(
                                    icon: CupertinoIcons.heart,
                                    text: recipe.likes.length.toString(),
                                    iconColor: ExtraColors.grey,
                                    textColor: ExtraColors.black),
                                FutureBuilder(
                                    future: getAverageReviewsRating(
                                        recipeID, context),
                                    builder: (context, snapshot) {
                                      return RecipeInfoItem(
                                          icon: Icons.grade,
                                          text: snapshot.data
                                                  ?.toStringAsFixed(1) ??
                                              '0.0',
                                          iconColor: ExtraColors.yellow,
                                          textColor: ExtraColors.black);
                                    }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
