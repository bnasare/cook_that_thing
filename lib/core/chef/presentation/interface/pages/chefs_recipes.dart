// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'all_chefs.dart';
import '../../../../recipes/presentation/bloc/recipe_mixin.dart';
import '../../../../recipes/presentation/interface/widgets/recipe_widget.dart';
import '../../../../../shared/data/firebase_constants.dart';
import '../../../../../shared/data/svg_assets.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/presentation/widgets/clickable.dart';
import '../../../../../src/home/presentation/interface/widgets/header.dart';
import '../../../../../src/profile/presentation/interface/pages/profile.dart';

import '../../../../../shared/presentation/widgets/error_view.dart';
import '../../../../../shared/presentation/widgets/shimmer.dart';
import '../../../../../src/home/presentation/interface/widgets/recipe_banner.dart';
import '../../../domain/entities/chef.dart';

class ChefsAndRecipes extends HookWidget with RecipeMixin {
  ChefsAndRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: SvgPicture.asset(SvgAssets.logo, width: 200),
        ),
        body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          children: [
            const RecipeBanner(
              title: 'Classic Chefs',
              subtitle:
                  'Explore world class recipes from top chefs across the world',
              svgAsset: SvgAssets.female,
            ),
            Header(
              leading: 'Featured Chefs',
              trailing: localizations.seeMore,
              onClick: () {
                NavigationHelper.navigateTo(context, AllChefsPage());
              },
            ),
            const SizedBox(height: 10),
            StreamBuilder<List<Chef>>(
              stream: listChefStream(FirebaseConsts.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitFadingCircle(
                    color: Theme.of(context).colorScheme.primary,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SizedBox(
                    height: 98,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          snapshot.data!.length > 4 ? 4 : snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String chefName = snapshot.data![index].name;
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: Clickable(
                            onClick: () => NavigationHelper.navigateTo(
                              context,
                              ProfilePage(chefID: snapshot.data![index].id),
                            ),
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: ExtraColors.white,
                                  radius: 35,
                                  child: Icon(
                                    CupertinoIcons.person_alt_circle_fill,
                                    color: ExtraColors.darkGrey,
                                    size: 45,
                                  ),
                                ),
                                Text(
                                  chefName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
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
            const Header(
              leading: 'Popular Recipes',
            ),
            StreamBuilder(
                stream: fetchAllRecipesSortedByAverageRatingStream(context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const ErrorViewWidget();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const ErrorViewWidget();
                  } else if (snapshot.hasData) {
                    int itemCount =
                        snapshot.data!.length > 6 ? 6 : snapshot.data!.length;
                    return RecipeWidget(
                        recipes: snapshot.data!, itemCount: itemCount);
                  } else {
                    return const ErrorViewWidget();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
