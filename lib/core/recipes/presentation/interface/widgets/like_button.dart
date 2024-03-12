import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/shared/data/collection_ids.dart';
import 'package:recipe_hub/shared/data/firebase_constants.dart';

import '../../../../../shared/platform/push_notification.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/clickable.dart';
import '../../bloc/recipe_mixin.dart';

class LikeButton extends HookWidget with RecipeMixin {
  final String recipeID;
  LikeButton(this.recipeID, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(DatabaseCollections.recipes)
            .doc(recipeID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            DocumentSnapshot recipeDoc = snapshot.data!;
            List<dynamic> likes = recipeDoc['likes'] ?? [];
            bool isLiked =
                likes.contains(FirebaseAuth.instance.currentUser!.uid);
            return Clickable(
              onClick: () async {
                // Toggle the like status
                List<String> newLikers = List<String>.from(likes);
                bool isLikedBeforeClick = isLiked;

                if (!isLikedBeforeClick) {
                  // Add the user's ID to the list of likers
                  newLikers.add(FirebaseConsts.currentUser!.uid);

                  // Update the likes in the database
                  await like(
                      recipeId: recipeID, likers: newLikers, context: context);

                  // Always retrieve the chefToken from the recipe document
                  String chefToken = recipeDoc['chefToken'] ?? '';
                  if (chefToken.isNotEmpty) {
                    // Initialize the push notification
                    final PushNotification pushNotification =
                        PushNotificationImpl(FlutterLocalNotificationsPlugin());

                    // Send the notification
                    await pushNotification.sendPushNotifs(
                      title:
                          'Hey there, ${FirebaseConsts.currentUser!.displayName} liked your recipe!',
                      body: '',
                      token: chefToken,
                    );
                  }
                } else {
                  // Remove the user's ID from the list of likers
                  newLikers.remove(FirebaseConsts.currentUser!.uid);
                }
              },
              child: Material(
                color: ExtraColors.grey,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    isLiked ? IconlyBold.heart : IconlyLight.heart,
                    color: isLiked
                        ? Theme.of(context).primaryColor
                        : ExtraColors.white,
                    size: isLiked ? 22 : 20,
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
