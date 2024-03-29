import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../shared/widgets/error_view.dart';

class RecipesTab extends HookWidget with ChefMixin {
  final String chefID;

  RecipesTab({super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    final fetchAllRecipes =
        useMemoized(() => fetchAllRecipesByChefID(context, chefID));

    return ListView(
      shrinkWrap: true,
      children: [
        StreamBuilder<List<Recipe>>(
          stream: fetchAllRecipes,
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (snapshot.hasError) {
              return const ErrorViewWidget();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const ErrorViewWidget();
            } else if (snapshot.hasData) {
              final recipes = snapshot.data!;
              return GridView.count(
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FancyShimmerImage(
                          width: double.infinity,
                          height: 200,
                          imageUrl: recipes.first.image,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(recipes.first.title,
                          overflow: TextOverflow.ellipsis),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(recipes.first.category),
                          Text(recipes.first.duration),
                        ],
                      )
                    ],
                  )
                ],
              );
            } else {
              return const ErrorViewWidget();
            }
          },
        )
      ],
    );
  }
}