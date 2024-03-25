import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../core/recipes/presentation/interface/pages/recipe_details.dart';
import '../../../../../core/recipes/presentation/interface/widgets/recipe_info.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/widgets/clickable.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';
import '../../../../home/presentation/interface/widgets/recipe_search_box.dart';

class FavoritesPage extends HookWidget with ChefMixin {
  FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalRecipes = useState<int?>(null);
    final searchController = useTextEditingController();
    final searchResults = useState<List<Recipe>?>(null);
    final localizations = AppLocalizations.of(context)!;

    void handleSearch(String query) async {
      if (query.isEmpty) {
        searchResults.value = null;
      } else {
        List<Recipe> allRecipes = await fetchFavorites(context).first;
        List<Recipe> filteredRecipes = allRecipes
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()) ||
                recipe.chef.toLowerCase().contains(query.toLowerCase()))
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

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites Recipes')),
      body: StreamBuilder(
          stream: fetchFavorites(context),
          builder: (context, snapshot) {
            final List<Recipe>? favoriteRecipes = snapshot.data;

            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 20),
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
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                  child: CustomSearchBox(
                      handleSearch: handleSearch,
                      controller: searchController,
                      label: 'Search',
                      hintText: 'Search recipe by title or chef',
                      readOnly:
                          favoriteRecipes == null || favoriteRecipes.isEmpty),
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
                                  padding: EdgeInsets.only(top: 50),
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
                                    );
                                  },
                                )
                          : searchController.text.isEmpty
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
                                    } else {
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
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: ExtraColors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ExtraColors
                                                          .darkGrey
                                                          .withOpacity(0.4),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(3, 3),
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
                                    }
                                  },
                                )
                              : const SizedBox(),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
