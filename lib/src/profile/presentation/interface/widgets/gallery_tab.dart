import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';

class GalleryTab extends HookWidget with ChefMixin {
  final String chefID;

  GalleryTab({super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 0),
      children: [
        StreamBuilder(
          stream: fetchAllRecipesByChefID(context, chefID),
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (snapshot.hasError) {
              return const ErrorViewWidget();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return const LoadingTextView(height: 150);
                  });
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const ErrorViewWidget();
            } else if (snapshot.hasData) {
              final recipes = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 10,
                ),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FancyShimmerImage(
                          width: double.infinity,
                          height: 150,
                          imageUrl: recipe.image,
                        ),
                      ),
                    ],
                  );
                },
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
