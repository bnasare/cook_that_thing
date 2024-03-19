// ignore_for_file: use_build_context_synchronously

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_widget.dart';
import 'package:recipe_hub/shared/data/firebase_constants.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/src/category/presentation/interface/widgets/category_tab.dart';
import 'package:recipe_hub/src/home/presentation/interface/widgets/header.dart';
import 'package:recipe_hub/src/home/presentation/interface/widgets/recipe_search_box.dart';

import '../../../../../core/chef/domain/entities/chef.dart';
import '../../../../../core/chef/presentation/interface/pages/all_chefs.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../shared/widgets/clickable.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';
import '../../../../category/presentation/interface/pages/list_category.dart';
import '../../../../profile/presentation/interface/pages/profile.dart';

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
        body: ColorfulSafeArea(
          color: Theme.of(context).primaryColor,
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
                      title: Text(
                        'Hello ${FirebaseConsts.currentUser!.displayName}!',
                        style: const TextStyle(
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
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Header(
                        leading: 'Categories',
                        trailing: localizations.seeMore,
                        onClick: () {
                          NavigationHelper.navigateTo(
                              context, const CategoryListPage());
                        },
                      ),
                    ),
                    const CategoryTab(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Header(
                        leading: 'Featured Chefs',
                        trailing: localizations.seeMore,
                        onClick: () {
                          NavigationHelper.navigateTo(context, AllChefsPage());
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    StreamBuilder<List<Chef>>(
                      stream: listChefStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SpinKitFadingCircle(
                            color: Theme.of(context).colorScheme.primary,
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return SizedBox(
                            height: 110,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length > 4
                                  ? 4
                                  : snapshot.data!.length,
                              itemBuilder: (context, index) {
                                String chefName = snapshot.data![index].name;
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.23,
                                  child: Clickable(
                                    onClick: () => NavigationHelper.navigateTo(
                                      context,
                                      ProfilePage(
                                          chefID: snapshot.data![index].id),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.person_alt_circle_fill,
                                          color: ExtraColors.darkGrey,
                                          size: 80,
                                        ),
                                        Text(
                                          chefName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Header(
                        leading: 'Popular Recipes',
                      ),
                    ),
                    StreamBuilder(
                        stream:
                            fetchAllRecipesSortedByAverageRatingStream(context),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            // If there's an error, return the error widget.
                            return const ErrorViewWidget();
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // If the connection is still waiting, show a loading indicator or not
                            return const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: LoadingTextView(
                                  height: 230, width: double.infinity),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isEmpty) {
                            // If there's data but the list is empty, show a "no data" message or
                            return const ErrorViewWidget();
                          } else if (snapshot.hasData) {
                            // If there's data, return the RecipeWidget.
                            int itemCount = snapshot.data!.length > 3
                                ? 3
                                : snapshot.data!.length;
                            return RecipeWidget(
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
