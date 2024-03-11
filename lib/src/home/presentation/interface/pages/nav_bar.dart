import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/pages/create_recipe.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/src/home/presentation/interface/pages/home.dart';
import 'package:recipe_hub/src/profile/presentation/interface/pages/profile.dart';

import '../../../../../core/recipes/presentation/interface/pages/all_recipes.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const AllRecipesPage(),
      const CreateRecipePage(),
      const ProfilePage(
        chefID: '',
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final localizations = AppLocalizations.of(context)!;

    return [
      PersistentBottomNavBarItem(
        textStyle: Theme.of(context).textTheme.bodySmall,
        icon: const Icon(Icons.home_filled),
        title: localizations.home,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: ExtraColors.darkGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        title: localizations.search,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: ExtraColors.darkGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.event_busy),
        title: localizations.cook,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: ExtraColors.darkGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: localizations.profile,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: ExtraColors.darkGrey,
      ),
    ];
  }

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
          color: Colors.black12,
        ), // Add a Divider widget here
        Expanded(
          child: PersistentTabView(
            context,
            controller: controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: ExtraColors.white,
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 900),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 900),
            ),
            navBarStyle: NavBarStyle.style3,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: false,
            decoration: const NavBarDecoration(
              border: Border(top: BorderSide(color: ExtraColors.lightGrey)),
            ),
            onWillPop: (context) async {
              if (controller.index == 0) {
                return true;
              }
              controller.jumpToTab(0);
              return false;
            },
          ),
        ),
      ],
    );
  }
}
