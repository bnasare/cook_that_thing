// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/chef/presentation/bloc/chef_mixin.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_grid_widget.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_info_item.dart';
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
                          style: Theme.of(context).textTheme.titleLarge),
                      StreamBuilder<List<Recipe>>(
                        stream: fetchAllRecipesByChefID(context, chefID),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Recipe>> snapshot) {
                          if (snapshot.hasError) {
                            return const ErrorViewWidget();
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return GridView.builder(
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
                            return const ErrorViewWidget();
                          } else if (snapshot.hasData) {
                            return RecipeGridWidget(recipes: snapshot.data!);
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                chef!.name,
                                style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                    height: 0),
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
                                            builder: (BuildContext context) {
                                              return LoginPage();
                                            },
                                          ),
                                          (_) => false,
                                        );
                                      },
                                      icon: const Icon(IconlyLight.logout,
                                          size: 18),
                                      label: const Text('Logout'))
                                  : StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('chefs')
                                          .doc(chefID)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.active &&
                                            snapshot.hasData) {
                                          DocumentSnapshot chefDoc =
                                              snapshot.data!;
                                          List<dynamic> followers =
                                              chefDoc['followers'] ?? [];
                                          bool isCurrentlyFollowing =
                                              followers.contains(FirebaseConsts
                                                  .currentUser!.uid);
                                          return InkWell(
                                            onTap: () async {
                                              if (isCurrentlyFollowing) {
                                                await follow(
                                                    context: context,
                                                    chefId: chefID,
                                                    followers: [],
                                                    token: []);
                                              } else {
                                                String? token =
                                                    await FirebaseMessaging
                                                        .instance
                                                        .getToken();
                                                await follow(
                                                    context: context,
                                                    chefId: chefID,
                                                    followers: [
                                                      FirebaseConsts
                                                          .currentUser!.uid
                                                    ],
                                                    token: [
                                                      token ?? ''
                                                    ]);
                                              }
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  border: Border.all(
                                                      color:
                                                          ExtraColors.darkGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Center(
                                                child: Text(
                                                  isCurrentlyFollowing
                                                      ? 'Unfollow'
                                                      : 'Follow',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: ExtraColors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    )
                            ],
                          );
                        }),
                    Divider(color: ExtraColors.darkGrey.withOpacity(0.3)),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder(
                              stream: retrieveFollowersCount(
                                  context: context,
                                  chefId:
                                      isCurrentUser ? currentUserID : chefID),
                              builder: (context, snapshot) {
                                final followersCount = snapshot.data ?? 0;
                                return RecipeInfoItem(
                                  icon: CupertinoIcons.person_2_alt,
                                  text: '$followersCount',
                                  iconColor: ExtraColors.grey,
                                  textColor: ExtraColors.black,
                                );
                              }),
                          StreamBuilder<int>(
                            stream: retrieveRecipeLength(context,
                                isCurrentUser ? currentUserID : chefID),
                            builder: (context, snapshot) {
                              final count = snapshot.data ?? 0;
                              return RecipeInfoItem(
                                icon: Icons.restaurant_rounded,
                                text: '$count',
                                iconColor: ExtraColors.grey,
                                textColor: ExtraColors.black,
                              );
                            },
                          ),
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
