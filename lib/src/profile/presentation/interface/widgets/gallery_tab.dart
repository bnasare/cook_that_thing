import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../shared/widgets/clickable.dart';
import '../../../../../shared/widgets/error_view.dart';

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
    return ListView(
      addAutomaticKeepAlives: true,
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      shrinkWrap: true,
      children: [
        StreamBuilder<List<Recipe>>(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (snapshot.hasError) {
              return const ErrorViewWidget();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const ErrorViewWidget();
            } else if (snapshot.hasData) {
              return GridView.builder(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.86,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final recipe = snapshot.data![index];
                    return Clickable(
                      onClick: () =>
                          openGallery(context, snapshot.data!, index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FancyShimmerImage(
                              width: double.infinity,
                              height: 210,
                              imageUrl: recipe.image,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return const ErrorViewWidget();
            }
          },
        )
      ],
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
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        );
      },
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
      pageController: PageController(initialPage: initialIndex),
    );
  }
}
