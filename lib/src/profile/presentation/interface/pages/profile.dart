import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/presentation/interface/widgets/follow_button.dart';
import '../../../../../shared/data/firebase_constants.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/loading_manager.dart';
import '../../../../../shared/widgets/warning_modal.dart';
import '../../../../authentication/presentation/interface/pages/login.dart';

class ProfilePage extends HookWidget with ChefMixin {
  final String chefID;

  ProfilePage({super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final currentUserID = FirebaseConsts.currentUser!.uid;
    final isCurrentUser = chefID == currentUserID;

    final chefStream = useMemoized(() => retrieveChefStream(
        context: context, chefId: isCurrentUser ? currentUserID : chefID));

    final recipeLength = useMemoized(() =>
        retrieveRecipeLength(context, isCurrentUser ? currentUserID : chefID));

    Future<void> signoutUser() async {
      isLoading.value = true;
      logoutUser(context: context);
      isLoading.value = false;
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginPage();
          },
        ),
        (_) => false,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingManager(
          isLoading: isLoading.value,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                const Center(
                    child: Icon(CupertinoIcons.person_alt_circle,
                        size: 130, color: ExtraColors.darkGrey)),
                StreamBuilder(
                  stream: chefStream,
                  builder: (context, snapshot) {
                    return Center(
                      child: Text(
                        snapshot.data?.name ?? 'Username',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 7),
                isCurrentUser
                    ? FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(80, 40),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return WarningModal(
                                title: "Sign Out",
                                content: "Are you sure you want to sign out?",
                                primaryButtonLabel: "YES",
                                primaryAction: () async {
                                  await signoutUser();
                                },
                              );
                            },
                          );
                        },
                        child: const Text('Logout',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)))
                    : FollowButton(chefID: chefID, height: 116, width: 40),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StreamBuilder(
                        stream: recipeLength,
                        builder: (context, snapshot) {
                          final recipesCount = snapshot.data ?? 0;
                          return Column(children: [
                            Text(recipesCount.toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ExtraColors.grey)),
                            Text(recipesCount == 1 ? 'Recipe' : 'Recipes',
                                style: const TextStyle(
                                    color: ExtraColors.darkGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ]);
                        }),
                    StreamBuilder(
                        stream: retrieveFollowersCount(
                            context: context,
                            chefId: isCurrentUser ? currentUserID : chefID),
                        builder: (context, snapshot) {
                          final followersCount = snapshot.data ?? 0;
                          return Column(children: [
                            Text(followersCount.toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ExtraColors.grey)),
                            Text(followersCount == 1 ? 'Follower' : 'Followers',
                                style: const TextStyle(
                                    color: ExtraColors.darkGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ]);
                        }),
                    StreamBuilder<double>(
                      stream:
                          getAverageChefReviewsRatingStream(chefID, context),
                      builder: (context, snapshot) {
                        final chefRating = snapshot.data ?? 0;
                        String rankText = '';
                        if (chefRating >= 4.5) {
                          rankText = 'Legend';
                        } else if (chefRating >= 3.5) {
                          rankText = 'Elite';
                        } else if (chefRating >= 2.5) {
                          rankText = 'Skilled';
                        } else if (chefRating >= 1.5) {
                          rankText = 'Novice';
                        } else {
                          rankText = 'Rookie';
                        }
                        return Column(
                          children: [
                            Text(rankText,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ExtraColors.grey)),
                            const Text('Rank',
                                style: TextStyle(
                                    color: ExtraColors.darkGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ],
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          indicatorWeight: 1,
                          dividerHeight: 1.5,
                          dividerColor: ExtraColors.lightGrey,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          labelStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          unselectedLabelColor: ExtraColors.grey,
                          tabs: const [
                            Tab(text: 'Recipes'),
                            Tab(text: 'Gallery'),
                            Tab(text: 'Reviews'),
                          ],
                        ),
                        const Expanded(
                          child: TabBarView(
                            children: [
                              // RecipesTab(chefID: chefID),
                              // GalleryTab(chefID: chefID),
                              // ReviewTab(chefID: chefID),
                              Center(child: Text('Hello')),
                              Center(child: Text('data')),
                              Center(child: Text('data')),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
