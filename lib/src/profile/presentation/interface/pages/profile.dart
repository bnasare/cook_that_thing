import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_grid_widget.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_info_item.dart';
import 'package:recipe_hub/shared/data/svg_assets.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class ProfilePage extends HookWidget {
  final String chefID;

  const ProfilePage({super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const SizedBox(
                      height: 300,
                      width: double.infinity,
                    ),
                    Positioned(child: SvgPicture.asset(SvgAssets.logo)),
                    Positioned(
                      top: 30,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: IconButton.filledTonal(
                              icon: const Icon(CupertinoIcons.backward),
                              onPressed: () =>
                                  NavigationHelper.navigateBack(context),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ExtraColors.white),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(20, 20)),
                                iconSize: MaterialStateProperty.all(20),
                                foregroundColor: MaterialStateProperty.all(
                                    ExtraColors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: IconButton.filledTonal(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ExtraColors.white),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(20, 20)),
                                iconSize: MaterialStateProperty.all(20),
                                foregroundColor: MaterialStateProperty.all(
                                    ExtraColors.black),
                              ),
                              icon: const Icon(IconlyLight.logout),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 85),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text('Chef\'s Recipes',
                          style: Theme.of(context).textTheme.titleLarge),
                      const RecipeGridWidget(),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.323,
              right: 0,
              left: 0,
              height: 130,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: ExtraColors.black.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 6.0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'King Cecil',
                      style: TextStyle(
                          fontSize: 23, fontWeight: FontWeight.w600, height: 0),
                    ),
                    Divider(color: ExtraColors.darkGrey.withOpacity(0.3)),
                    const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RecipeInfoItem(
                              icon: CupertinoIcons.person_2_alt,
                              text: '34',
                              iconColor: ExtraColors.grey,
                              textColor: ExtraColors.black),
                          RecipeInfoItem(
                              icon: Icons.restaurant_rounded,
                              text: '36',
                              iconColor: ExtraColors.grey,
                              textColor: ExtraColors.black),
                          RecipeInfoItem(
                              icon: Icons.star,
                              text: '4.5',
                              iconColor: ExtraColors.yellow,
                              textColor: ExtraColors.black),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
