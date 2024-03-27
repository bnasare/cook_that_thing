import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../core/recipes/presentation/interface/pages/recipe_details.dart';
import '../../../../../core/recipes/presentation/interface/widgets/recipe_info.dart';
import '../../../../../shared/data/collection_ids.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/widgets/clickable.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';
import '../../../../../shared/widgets/snackbar.dart';
import '../../../../home/presentation/interface/widgets/recipe_search_box.dart';

class FavoritesPage extends HookWidget with ChefMixin {
  FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalRecipes = useState<int?>(null);
    final searchController = useTextEditingController();
    final searchResults = useState<List<Recipe>?>(null);
    final localizations = AppLocalizations.of(context)!;

    Future<void> clearFavoriteRecipes() async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return; // Early return if user is not logged in

        final chefDocRef =
            FirebaseFirestore.instance.collection('chefs').doc(user.uid);
        final chefDocSnapshot = await chefDocRef.get();

        if (!chefDocSnapshot.exists) {
          log('Chef document does not exist.');
          return;
        }

        final chefData = chefDocSnapshot.data();
        if (chefData == null ||
            !chefData.containsKey('favorites') ||
            (chefData['favorites'] as List).isEmpty) {
          log('No favorites to clear or already cleared.');
          return;
        }

        final List<String> favoriteRecipes =
            List<String>.from(chefData['favorites']);

        // Create a batch to perform all writes efficiently
        final batch = FirebaseFirestore.instance.batch();

        // Clear favorite array inside the chef document
        batch.update(chefDocRef, {'favorites': []});

        // Track recipes to be removed from favoriteRecipes collection
        final recipesToDelete = <String>{};

        // Loop through favorites, checking existence in Recipes collection
        for (final recipeId in favoriteRecipes) {
          final recipeDocRef = FirebaseFirestore.instance
              .collection(DatabaseCollections.recipes)
              .doc(recipeId);
          final recipeDocSnapshot = await recipeDocRef.get();

          if (recipeDocSnapshot.exists) {
            recipesToDelete.add(recipeId);

            // Update the recipe's likes within the batch
            batch.update(recipeDocRef, {
              'likes': FieldValue.arrayRemove([user.uid])
            });
          } else {
            log('Recipe $recipeId does not exist. Skipping update.');
          }
        }

        // Delete only the relevant favorite recipe documents
        for (final recipeId in recipesToDelete) {
          batch.delete(FirebaseFirestore.instance
              .collection('favoriteRecipes')
              .doc('${user.uid}_$recipeId'));
        }

        // Commit the batch operation
        await batch.commit();
        totalRecipes.value = 0;
        searchResults.value = null;
      } catch (error) {
        // Log or handle the error accordingly
        log('Error clearing favorites: $error');
      }
    }

    void handleSearch(String query) async {
      if (query.isEmpty) {
        searchResults.value = null;
      } else {
        List<Recipe> allRecipes = await fetchFavorites(context).first;
        List<Recipe> filteredRecipes = allRecipes
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searchResults.value = filteredRecipes;
      }
    }

    useEffect(() {
      final StreamSubscription<List<Recipe>> subscription =
          fetchFavorites(context).listen((favoriteRecipes) {
        totalRecipes.value = favoriteRecipes.length;
      }, onError: (error) {
        debugPrint(error.toString());
      });

      return subscription.cancel;
    }, []);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: const Text('Favorites Recipes')),
          body: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                title: Text(
                  searchController.text.isNotEmpty
                      ? '${searchResults.value?.length ?? 0} ${searchResults.value != null && searchResults.value!.length == 1 ? localizations.recipeFoundSingular : localizations.recipeFoundPlural}'
                      : '${totalRecipes.value != null ? '${totalRecipes.value}' : '0'} ${totalRecipes.value == 1 ? localizations.recipeInTotalSingular : localizations.recipeInTotalPlural} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ExtraColors.grey,
                    fontSize: 17,
                  ),
                ),
                subtitle: const Text(
                  'Enjoy your favorite recipes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: ExtraColors.darkGrey,
                  ),
                ),
                trailing: Clickable(
                  onClick: () {
                    if (totalRecipes.value != null && totalRecipes.value! > 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            shadowColor: ExtraColors.white,
                            title: const Text('Clear All Favorites'),
                            content: const Text(
                                'Are you sure you want to clear all favorite recipes?',
                                style: TextStyle(fontSize: 18)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 18)),
                              ),
                              TextButton(
                                onPressed: () {
                                  clearFavoriteRecipes();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Clear',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 18)),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      SnackBarHelper.showErrorSnackBar(
                          context, 'Nothing to delete');
                    }
                  },
                  child: Icon(
                    IconlyLight.delete,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                child: CustomSearchBox(
                    handleSearch: handleSearch,
                    controller: searchController,
                    label: 'Search',
                    hintText: 'Search recipe by title or chef',
                    enabled:
                        totalRecipes.value == 0 || totalRecipes.value == null
                            ? false
                            : true,
                    readOnly:
                        totalRecipes.value == 0 || totalRecipes.value == null),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  shrinkWrap: true,
                  children: [
                    searchResults.value != null &&
                            searchController.text.isNotEmpty
                        ? searchResults.value!.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: ErrorViewWidget(),
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 20),
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: searchResults.value!.length,
                                itemBuilder: (context, index) {
                                  Recipe recipe = searchResults.value![index];
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ExtraColors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ExtraColors.darkGrey
                                                .withOpacity(0.4),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(3, 3),
                                          )
                                        ]),
                                    child: RecipeInfo(
                                      recipe: recipe,
                                      recipeID: recipe.id,
                                    ),
                                  );
                                },
                              )
                        : searchController.text.isEmpty ||
                                searchResults.value == null
                            ? StreamBuilder<List<Recipe>>(
                                stream: fetchFavorites(context),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 80.0),
                                      child: ErrorViewWidget(),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return const LoadingTextView(
                                            height: 130,
                                            width: double.infinity);
                                      },
                                      itemCount: snapshot.data?.length ?? 5,
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    // Add this condition to handle no data or an empty list
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 80.0),
                                      child: ErrorViewWidget(),
                                    );
                                  } else if (snapshot.hasData) {
                                    // If there's data, build a list of RecipeInfo widgets
                                    return ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 20),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        Recipe recipe = snapshot.data![index];
                                        return Clickable(
                                          onClick: () =>
                                              NavigationHelper.navigateTo(
                                                  context,
                                                  RecipeDetailsPage(
                                                      recipeID: recipe.id)),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ExtraColors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: ExtraColors.darkGrey
                                                        .withOpacity(0.4),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: const Offset(3, 3),
                                                  )
                                                ]),
                                            child: RecipeInfo(
                                              recipe: recipe,
                                              recipeID: recipe.id,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 80.0),
                                      child: ErrorViewWidget(),
                                    );
                                  }
                                },
                              )
                            : const ErrorViewWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
