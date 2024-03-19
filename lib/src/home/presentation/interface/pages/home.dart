// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/pages/all_recipes.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_grid_widget.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/src/category/presentation/interface/widgets/category_tab.dart';
import 'package:recipe_hub/src/home/presentation/interface/widgets/header.dart';
import 'package:recipe_hub/src/home/presentation/interface/widgets/recipe_search_box.dart';

import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';
import '../../../../category/presentation/interface/pages/list_category.dart';

class HomePage extends HookWidget with RecipeMixin {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final searchController = useTextEditingController();
    final searchResults = useState<List<Recipe>?>(null);

    void handleSearch(String query) async {
      if (query.isEmpty) {
        searchResults.value = null;
      } else {
        List<Recipe> allRecipes = await fetchAllRecipes(context).first;
        List<Recipe> filteredRecipes = allRecipes
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()) ||
                recipe.category.toLowerCase().contains(query.toLowerCase()) ||
                recipe.diet.toLowerCase().contains(query.toLowerCase()) ||
                recipe.difficultyLevel
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                recipe.chef.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searchResults.value = filteredRecipes;
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.elliptical(20, 12),
                        bottomRight: Radius.elliptical(20, 12))),
                child: Column(
                  children: [
                    ListTile(
                      horizontalTitleGap: 5,
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(CupertinoIcons.person_alt_circle_fill,
                          size: 50),
                      title: const Text(
                        'Hello Benedict!',
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: ExtraColors.white),
                      ),
                      subtitle: Text(
                        'Check out our amazing recipes',
                        style: TextStyle(
                            height: -2.39,
                            overflow: TextOverflow.ellipsis,
                            color: ExtraColors.white.withOpacity(0.7)),
                      ),
                    ),
                    const Spacer(),
                    CustomSearchBox(
                      handleSearch: handleSearch,
                      controller: searchController,
                      label: 'Search',
                      hintText:
                          'Search recipes by title, category, difficulty or chef',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  children: [
                    Header(
                      leading: localizations.category,
                      trailing: localizations.seeMore,
                      onClick: () {
                        NavigationHelper.navigateTo(
                            context, const CategoryListPage());
                      },
                    ),
                    const CategoryTab(),
                    Header(
                        leading: localizations.proCook,
                        trailing: localizations.seeMore,
                        onClick: () {
                          NavigationHelper.navigateTo(
                              context, AllRecipesPage());
                        }),
                    StreamBuilder(
                        stream: fetchAllRecipes(context),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            // If there's an error, return the error widget.
                            return const ErrorViewWidget();
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // If the connection is still waiting, show a loading indicator or not
                            return GridView.builder(
                              padding: const EdgeInsets.only(top: 20),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return const LoadingTextView(height: 25);
                              },
                              itemCount: 8,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      crossAxisCount: 2),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isEmpty) {
                            // If there's data but the list is empty, show a "no data" message or
                            return const ErrorViewWidget();
                          } else if (snapshot.hasData) {
                            // If there's data, return the RecipeGridWidget.
                            int itemCount = snapshot.data!.length > 6
                                ? 6
                                : snapshot.data!.length;
                            return RecipeGridWidget(
                                recipes: snapshot.data!, itemCount: itemCount);
                          } else {
                            // If the snapshot is neither loading, with error, nor with data, show
                            return const ErrorViewWidget();
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
