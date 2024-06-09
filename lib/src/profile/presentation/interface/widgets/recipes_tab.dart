import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../core/recipes/presentation/interface/pages/recipe_details.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/clickable.dart';
import '../../../../../shared/presentation/widgets/error_view.dart';

class RecipesTab extends HookWidget with ChefMixin {
  final String chefID;
  final Stream<List<Recipe>>? stream;

  RecipesTab(this.stream, {super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Recipe>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
        if (snapshot.hasError) {
          return const SingleChildScrollView(child: ErrorViewWidget());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const SingleChildScrollView(child: ErrorViewWidget());
        } else if (snapshot.hasData) {
          return Clickable(
            onClick: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return RecipeDetailsPage(recipeID: snapshot.data![0].id);
                },
              ),
            ),
            child: GridView.builder(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.87,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final recipe = snapshot.data![index];
                  return Container(
                    decoration: BoxDecoration(
                      color: ExtraColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: ExtraColors.darkGrey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FancyShimmerImage(
                              width: double.infinity,
                              imageUrl: recipe.image,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    recipe.category,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: ExtraColors.grey,
                                    ),
                                  ),
                                  Text(
                                    recipe.duration,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: ExtraColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        } else {
          return const SingleChildScrollView(child: ErrorViewWidget());
        }
      },
    );
  }
}
