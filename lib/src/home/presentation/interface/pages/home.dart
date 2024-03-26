// ignore_for_file: use_build_context_synchronously

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/chef/domain/entities/chef.dart';
import '../../../../../core/chef/presentation/interface/pages/all_chefs.dart';
import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../core/recipes/presentation/bloc/recipe_mixin.dart';
import '../../../../../core/recipes/presentation/interface/pages/all_recipes.dart';
import '../../../../../core/recipes/presentation/interface/pages/recipe_details.dart';
import '../../../../../core/recipes/presentation/interface/widgets/recipe_info.dart';
import '../../../../../core/recipes/presentation/interface/widgets/recipe_widget.dart';
import '../../../../../shared/data/firebase_constants.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/widgets/clickable.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';
import '../../../../category/presentation/interface/pages/list_category.dart';
import '../../../../category/presentation/interface/widgets/category_tab.dart';
import '../../../../profile/presentation/interface/pages/profile.dart';
import '../widgets/header.dart';
import '../widgets/recipe_search_box.dart';

class HomePage extends HookWidget with RecipeMixin {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final searchController = useTextEditingController();
    final searchResults = useState<List<Recipe>?>(null);

    final Stream<List<Chef>> chefStream = listChefStreams();
    final Stream<List<Recipe>> popularRecipesStream =
        fetchAllRecipesSortedByAverageRatingStream(context);
    final Stream<List<Recipe>> newRecipesStream = fetchAllRecipes(context);
    final Stream<List<Recipe>> newRecipesStreamm = fetchAllRecipes(context);

    void handleSearch(String query) async {
      if (query.isEmpty) {
        searchResults.value = null;
      } else {
        List<Recipe> allRecipes = await fetchAllRecipes(context).first;
        List<Recipe> filteredRecipes = allRecipes
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()) ||
                recipe.chef.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searchResults.value = filteredRecipes;
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder(
            stream: newRecipesStream,
            builder: (context, snapshot) {
              final List<Recipe>? newRecipes = snapshot.data;

              return ColorfulSafeArea(
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
                            leading: const Icon(
                                CupertinoIcons.person_alt_circle,
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
                            fillColor: ExtraColors.white,
                            controller: searchController,
                            label: 'Search',
                            hintText: 'Search recipe by title or chef',
                            readOnly: newRecipes == null || newRecipes.isEmpty,
                            enabled: newRecipes == null || newRecipes.isEmpty
                                ? false
                                : true,
                          ),
                        ],
                      ),
                    ),
                    searchResults.value != null &&
                            searchController.text.isNotEmpty
                        ? searchResults.value!.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 50.0),
                                child: ErrorViewWidget(),
                              )
                            : Expanded(
                                child: ListView.separated(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                              ))
                        : searchController.text.isEmpty
                            ? Expanded(
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 20, right: 20),
                                      child: Header(
                                        leading: 'Categories',
                                        trailing: localizations.seeMore,
                                        onClick: () {
                                          NavigationHelper.navigateTo(context,
                                              const CategoryListPage());
                                        },
                                      ),
                                    ),
                                    const CategoryTab(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 20, right: 20),
                                      child: Header(
                                        leading: 'Featured Chefs',
                                        trailing: localizations.seeMore,
                                        onClick: () {
                                          NavigationHelper.navigateTo(
                                              context, AllChefsPage());
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: StreamBuilder<List<Chef>>(
                                        stream: chefStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SpinKitFadingCircle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return SizedBox(
                                              height: 110,
                                              child: ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    snapshot.data!.length > 4
                                                        ? 4
                                                        : snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  String chefName = snapshot
                                                      .data![index].name;
                                                  return SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.23,
                                                    child: Clickable(
                                                      onClick: () => NavigationHelper
                                                          .navigateTo(
                                                              context,
                                                              ProfilePage(
                                                                  chefID: snapshot
                                                                      .data![
                                                                          index]
                                                                      .id)),
                                                      child: Column(
                                                        children: [
                                                          const Icon(
                                                              CupertinoIcons
                                                                  .person_alt_circle,
                                                              color: ExtraColors
                                                                  .darkGrey,
                                                              size: 80),
                                                          Text(
                                                            chefName,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
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
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 15, left: 20, right: 20),
                                      child: Header(
                                        leading: 'Popular Recipes',
                                      ),
                                    ),
                                    StreamBuilder<List<Recipe>>(
                                      stream: popularRecipesStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          // If there's an error, return the error widget.
                                          return const ErrorViewWidget();
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // If the connection is still waiting, show a loading indicator or not
                                          return const Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0,
                                                left: 20,
                                                right: 20,
                                                bottom: 20),
                                            child: LoadingTextView(
                                                height: 230,
                                                width: double.infinity),
                                          );
                                        } else if (snapshot.hasData &&
                                            snapshot.data!.isEmpty) {
                                          // If there's data but the list is empty, show a "no data" message or
                                          return const ErrorViewWidget();
                                        } else if (snapshot.hasData) {
                                          // If there's data, return the RecipeWidget.
                                          int itemCount =
                                              snapshot.data!.length > 4
                                                  ? 4
                                                  : snapshot.data!.length;
                                          return RecipeWidget(
                                              width: 300,
                                              recipes: snapshot.data!,
                                              itemCount: itemCount);
                                        } else {
                                          // If the snapshot is neither loading, with error, nor with data, show
                                          return const ErrorViewWidget();
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 20, right: 20),
                                      child: Header(
                                        leading: 'New Recipes',
                                        trailing: localizations.seeMore,
                                        onClick: () =>
                                            NavigationHelper.navigateTo(
                                                context, AllRecipesPage()),
                                      ),
                                    ),
                                    StreamBuilder<List<Recipe>>(
                                        stream: newRecipesStreamm,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            // If there's an error, return the error widget.
                                            return const ErrorViewWidget();
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            // If the connection is still waiting, show a loading indicator or not
                                            return const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20),
                                              child: LoadingTextView(
                                                  height: 140,
                                                  width: double.infinity),
                                            );
                                          } else if (snapshot.hasData &&
                                              snapshot.data!.isEmpty) {
                                            // If there's data but the list is empty, show a "no data" message or
                                            return const ErrorViewWidget();
                                          } else if (snapshot.hasData) {
                                            return SizedBox(
                                              height: 160,
                                              width: 300,
                                              child: ListView.separated(
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(width: 20),
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 20),
                                                addSemanticIndexes: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    snapshot.data!.length > 4
                                                        ? 4
                                                        : snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  return Clickable(
                                                    onClick: () => NavigationHelper
                                                        .navigateTo(
                                                            context,
                                                            RecipeDetailsPage(
                                                                recipeID: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id)),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 5,
                                                              top: 10,
                                                              bottom: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              ExtraColors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: ExtraColors
                                                                  .darkGrey
                                                                  .withOpacity(
                                                                      0.4),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset:
                                                                  const Offset(
                                                                      3, 3),
                                                            )
                                                          ]),
                                                      child: SizedBox(
                                                        width: 290,
                                                        height: 160,
                                                        child: RecipeInfo(
                                                          recipe: snapshot
                                                              .data![index],
                                                          recipeID: snapshot
                                                              .data![index].id,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            // If the snapshot is neither loading, with error, nor with data, show
                                            return const ErrorViewWidget();
                                          }
                                        }),
                                  ],
                                ),
                              )
                            : const ErrorViewWidget(),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
