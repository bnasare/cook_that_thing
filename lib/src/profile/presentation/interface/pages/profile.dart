// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/chef/presentation/bloc/chef_mixin.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/follow_button.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_info_item.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_widget.dart';
import 'package:recipe_hub/shared/data/firebase_constants.dart';
import 'package:recipe_hub/shared/data/svg_assets.dart';
import 'package:recipe_hub/src/authentication/presentation/interface/pages/login.dart';

import '../../../../../core/recipes/domain/entities/recipe.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/shimmer.dart';

class ProfilePage extends HookWidget with ChefMixin {
  final String chefID;

  ProfilePage({super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseConsts.currentUser!.uid;
    final isCurrentUser = chefID == currentUserID;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      color: ExtraColors.lightGrey,
                    ),
                    Positioned(
                        child: Center(
                            child:
                                SvgPicture.asset(SvgAssets.book, height: 300))),
                  ],
                ),
                const SizedBox(height: 85),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text('Chef\'s Recipes',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20)),
                      StreamBuilder<List<Recipe>>(
                        stream: fetchAllRecipesByChefID(context, chefID),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Recipe>> snapshot) {
                          if (snapshot.hasError) {
                            return const ErrorViewWidget();
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: LoadingTextView(
                                  height: 230, width: double.infinity),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isEmpty) {
                            return const ErrorViewWidget();
                          } else if (snapshot.hasData) {
                            return RecipeWidget(
                                sizedBoxHeight: 20,
                                recipes: snapshot.data!,
                                height: null,
                                axis: Axis.vertical);
                          } else {
                            return const ErrorViewWidget();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.26,
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
                  children: [
                    const SizedBox(height: 11),
                    StreamBuilder(
                        stream: retrieveChefStream(
                            context: context,
                            chefId: isCurrentUser ? currentUserID : chefID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingTextView(
                              height: 30,
                              width: 75,
                            );
                          }
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }
                          final chef = snapshot.data;
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      chef!.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  isCurrentUser
                                      ? FilledButton.icon(
                                          style: FilledButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            minimumSize: const Size(75, 35),
                                          ),
                                          onPressed: () {
                                            logoutUser(context: context);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return LoginPage();
                                                },
                                              ),
                                              (_) => false,
                                            );
                                          },
                                          icon: const Icon(IconlyLight.logout,
                                              size: 18),
                                          label: const Text('Logout'))
                                      : SizedBox(
                                          width: 115,
                                          child: FollowButton(chefID: chefID)),
                                ],
                              ),
                            ),
                          );
                        }),
                    Divider(color: ExtraColors.darkGrey.withOpacity(0.3)),
                    const SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder(
                            stream: retrieveFollowersCount(
                                context: context,
                                chefId: isCurrentUser ? currentUserID : chefID),
                            builder: (context, snapshot) {
                              final followersCount = snapshot.data ?? 0;
                              return RecipeInfoItem(
                                icon: CupertinoIcons.person_add_solid,
                                text: '$followersCount',
                                iconSize: 20,
                                width: 4,
                                textSize: 20,
                                iconColor: ExtraColors.grey,
                                textColor: ExtraColors.black,
                              );
                            }),
                        StreamBuilder<int>(
                          stream: retrieveRecipeLength(
                              context, isCurrentUser ? currentUserID : chefID),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return RecipeInfoItem(
                              icon: Icons.restaurant_rounded,
                              text: '$count',
                              textSize: 20,
                              iconSize: 20,
                              width: 4,
                              iconColor: ExtraColors.grey,
                              textColor: ExtraColors.black,
                            );
                          },
                        ),
                      ],
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
