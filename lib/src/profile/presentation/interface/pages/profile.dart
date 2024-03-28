import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/chef/presentation/bloc/chef_mixin.dart';
import '../../../../../core/recipes/presentation/interface/widgets/follow_button.dart';
import '../../../../../core/review/domain/entities/review.dart';
import '../../../../../core/review/presentation/interface/widgets/review_card.dart';
import '../../../../../shared/data/firebase_constants.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/loading_manager.dart';
import '../../../../../shared/widgets/warning_modal.dart';
import '../../../../authentication/presentation/interface/pages/login.dart';
import '../widgets/gallery_tab.dart';
import '../widgets/recipes_tab.dart';

class ProfilePage extends HookWidget with ChefMixin {
  final String chefID;

  ProfilePage({super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final currentUserID = FirebaseConsts.currentUser!.uid;
    final isCurrentUser = chefID == currentUserID;

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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 100.0),
                const Center(
                    child: Icon(CupertinoIcons.person_alt_circle,
                        size: 80, color: ExtraColors.darkGrey)),
                const SizedBox(height: 25.0),
                StreamBuilder(
                  stream: retrieveChefStream(
                      context: context,
                      chefId: isCurrentUser ? currentUserID : chefID),
                  builder: (context, snapshot) {
                    return Center(
                      child: Text(
                        snapshot.data?.name ?? 'User name',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),
                isCurrentUser
                    ? FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(75, 35),
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
                        child: const Text('Logout'))
                    : FollowButton(chefID: chefID),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StreamBuilder(
                        stream: retrieveRecipeLength(
                            context, isCurrentUser ? currentUserID : chefID),
                        builder: (context, snapshot) {
                          final recipesCount = snapshot.data ?? 0;
                          return Column(children: [
                            Text(recipesCount.toString(),
                                style: const TextStyle(fontSize: 18)),
                            Text(recipesCount == 1 ? 'Recipe' : 'Recipes'),
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
                                style: const TextStyle(fontSize: 18)),
                            Text(
                                followersCount == 1 ? 'Follower' : 'Followers'),
                          ]);
                        }),
                    StreamBuilder<double>(
                        stream: getAverageChefReviewsRatingStream(
                            isCurrentUser ? currentUserID : chefID, context),
                        builder: (context, snapshot) {
                          final chefRating = snapshot.data ?? 0;
                          String ratingText = '';
                          if (chefRating >= 4.5) {
                            ratingText = 'Excellent Chef';
                          } else if (chefRating >= 3.5) {
                            ratingText = 'Great Chef';
                          } else if (chefRating >= 2.5) {
                            ratingText = 'Good Chef';
                          } else if (chefRating >= 1.5) {
                            ratingText = 'Okay Chef';
                          } else {
                            ratingText = 'Needs Improvement!';
                          }
                          return Column(
                            children: [
                              Text('$chefRating',
                                  style: const TextStyle(fontSize: 18)),
                              FittedBox(child: Text(ratingText)),
                            ],
                          );
                        })
                  ],
                ),
                const SizedBox(height: 40.0),
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          dividerHeight: 1,
                          dividerColor: ExtraColors.darkGrey,
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
                        Expanded(
                          child: TabBarView(
                            children: [
                              RecipesTab(
                                  chefID:
                                      isCurrentUser ? currentUserID : chefID),
                              GalleryTab(
                                  chefID:
                                      isCurrentUser ? currentUserID : chefID),
                              StreamBuilder(
                                  stream: fetchReviewsByChefID(context, chefID),
                                  builder: (context, snapshot) {
                                    List<Review> reviews = snapshot.data;
                                    if (snapshot.hasError) {
                                      return const ErrorViewWidget();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    } else if (snapshot.hasData &&
                                        snapshot.data!.isEmpty) {
                                      return const ErrorViewWidget();
                                    } else if (snapshot.hasData) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        scrollDirection: Axis.vertical,
                                        itemCount: reviews.length,
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                                color: ExtraColors.lightGrey,
                                                thickness: 2),
                                        itemBuilder: (context, index) {
                                          return ReviewCard(
                                            name: reviews[index].name,
                                            rating: reviews[index].rating,
                                            time: reviews[index].time,
                                            review: reviews[index].review,
                                          );
                                        },
                                      );
                                    } else {
                                      return const ErrorViewWidget();
                                    }
                                  }),
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
