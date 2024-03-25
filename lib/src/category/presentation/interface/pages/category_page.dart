import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../core/recipes/presentation/bloc/recipe_mixin.dart';
import '../../../../../core/recipes/presentation/interface/pages/recipe_details.dart';
import '../../../../../core/recipes/presentation/interface/widgets/recipe_info.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/widgets/clickable.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../home/presentation/interface/widgets/recipe_search_box.dart';

class RecipeCategoryPage extends HookWidget with RecipeMixin {
  final String category;

  RecipeCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final totalRecipes = useState<int?>(null);
    final localizations = AppLocalizations.of(context)!;
    final searchController = useTextEditingController();
    final searchResults = useState<List<Recipe>?>(null);

    void handleSearch(String query) async {
      if (query.isEmpty) {
        searchResults.value = null;
      } else {
        List<Recipe> allRecipes =
            await fetchAllRecipesByCategory(context, category).first;
        List<Recipe> filteredRecipes = allRecipes
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()) ||
                recipe.chef.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searchResults.value = filteredRecipes;
      }
    }

    Future<void> fetchTotalRecipes() async {
      try {
        final List<Recipe> allRecipes =
            await fetchAllRecipesByCategory(context, category).first;
        totalRecipes.value = allRecipes.length;
      } catch (error) {
        debugPrint(error.toString());
      }
    }

    useEffect(() {
      fetchTotalRecipes();
      return () {};
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: StreamBuilder(
          stream: fetchAllRecipesByCategory(context, category),
          builder: (context, snapshot) {
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
                  ),
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
                                  stream: fetchAllRecipesByCategory(
                                      context, category),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 90.0),
                                        child: ErrorViewWidget(),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3),
                                        child: SpinKitFadingCircle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      );
                                    } else if (snapshot.hasData &&
                                        snapshot.data!.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 90.0),
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
                                    } else {
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 90.0),
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
            );
          }),
    );
  }
}
