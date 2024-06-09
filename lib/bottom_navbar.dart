import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'core/recipes/presentation/interface/pages/create_recipe_method.dart';
import 'shared/data/firebase_constants.dart';
import 'shared/presentation/theme/extra_colors.dart';
import 'src/favorite/presentation/interface/pages/favorites.dart';
import 'src/home/presentation/interface/pages/home.dart';
import 'src/profile/presentation/interface/pages/profile.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late PersistentTabController controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 0,
          color: ExtraColors.grey,
        ),
        Flexible(
          child: PersistentTabView(
            navBarBuilder: (navBarConfig) => Style2BottomNavBar(
              navBarDecoration: const NavBarDecoration(
                border: Border(top: BorderSide(color: ExtraColors.lightGrey)),
              ),
              navBarConfig: navBarConfig,
              itemPadding:
                  const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
              itemAnimationProperties: const ItemAnimation(
                duration: Duration(milliseconds: 700),
                curve: Curves.ease,
              ),
            ),
            navBarHeight: 65,
            backgroundColor: ExtraColors.white,
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            screenTransitionAnimation: const ScreenTransitionAnimation(
              curve: Curves.ease,
              duration: Duration(milliseconds: 700),
            ),
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: false,
            tabs: [
              PersistentTabConfig(
                screen: HomePage(),
                item: ItemConfig(
                  title: "Home",
                  textStyle: Theme.of(context).textTheme.labelLarge!,
                  icon: const Icon(IconlyLight.home),
                  activeColorSecondary: Theme.of(context).colorScheme.primary,
                  inactiveBackgroundColor: ExtraColors.darkGrey,
                ),
              ),
              PersistentTabConfig(
                screen: FavoritesPage(),
                item: ItemConfig(
                  title: "Favorites",
                  textStyle: Theme.of(context).textTheme.labelLarge!,
                  icon: const Icon(IconlyLight.heart),
                  activeForegroundColor: Theme.of(context).colorScheme.primary,
                  inactiveForegroundColor: ExtraColors.darkGrey,
                ),
              ),
              PersistentTabConfig(
                screen: const CreateRecipeChoicePage(),
                item: ItemConfig(
                  title: "Cook",
                  textStyle: Theme.of(context).textTheme.labelLarge!,
                  icon: const Icon(IconlyLight.activity),
                  activeForegroundColor: Theme.of(context).colorScheme.primary,
                  inactiveForegroundColor: ExtraColors.darkGrey,
                ),
              ),
              PersistentTabConfig(
                screen: ProfilePage(chefID: FirebaseConsts.currentUser!.uid),
                item: ItemConfig(
                  title: "Profile",
                  textStyle: Theme.of(context).textTheme.labelLarge!,
                  icon: const Icon(IconlyLight.profile),
                  activeForegroundColor: Theme.of(context).colorScheme.primary,
                  inactiveForegroundColor: ExtraColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
