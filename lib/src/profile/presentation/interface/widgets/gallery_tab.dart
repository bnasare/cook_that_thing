import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/clickable.dart';
import '../../../../../shared/presentation/widgets/error_view.dart';

class GalleryTab extends HookWidget with ChefMixin {
  final Stream<List<Recipe>>? stream;
  final String chefID;

  GalleryTab(this.stream, {super.key, required this.chefID});

  void openGallery(
      BuildContext context, List<Recipe> recipes, int initialIndex) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return GalleryView(recipes: recipes, initialIndex: initialIndex);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Recipe>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
        if (snapshot.hasError) {
          return const ErrorViewWidget();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const ErrorViewWidget();
        } else if (snapshot.hasData) {
          return GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                childAspectRatio: 0.86,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final recipe = snapshot.data![index];
                return Clickable(
                  onClick: () => openGallery(context, snapshot.data!, index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FancyShimmerImage(
                      width: double.infinity,
                      height: 180,
                      imageUrl: recipe.image,
                    ),
                  ),
                );
              });
        } else {
          return const ErrorViewWidget();
        }
      },
    );
  }
}

class GalleryView extends StatelessWidget {
  final List<Recipe> recipes;
  final int initialIndex;

  const GalleryView(
      {super.key, required this.recipes, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: recipes.length,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(recipes[index].image),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
        );
      },
      backgroundDecoration: const BoxDecoration(
        color: ExtraColors.black,
      ),
      pageController: PageController(initialPage: initialIndex),
    );
  }
}
