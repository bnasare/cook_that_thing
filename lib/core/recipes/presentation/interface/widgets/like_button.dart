// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iconly/iconly.dart';

import '../../../../../shared/data/collection_ids.dart';
import '../../../../../shared/platform/push_notification.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/clickable.dart';
import '../../../../../shared/presentation/widgets/snackbar.dart';
import '../../bloc/recipe_mixin.dart';

class LikeButton extends StatefulWidget {
  final String recipeID;

  const LikeButton(this.recipeID, {super.key});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with RecipeMixin {
  late bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIsLiked();
  }

  Future<void> _checkIsLiked() async {
    FirebaseFirestore.instance
        .collection(DatabaseCollections.recipes)
        .doc(widget.recipeID)
        .snapshots()
        .listen((DocumentSnapshot recipeDoc) {
      if (recipeDoc.exists) {
        List<dynamic> likes = recipeDoc['likes'] ?? [];
        bool isLiked = likes.contains(FirebaseAuth.instance.currentUser!.uid);

        if (mounted) {
          setState(() {
            _isLiked = isLiked;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onClick: () async {
        bool newIsLiked = !_isLiked;
        setState(() {
          _isLiked = newIsLiked;
        });

        try {
          DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
              .collection(DatabaseCollections.recipes)
              .doc(widget.recipeID)
              .get();

          List<dynamic> likes = recipeDoc['likes'] ?? [];
          bool isLiked = likes.contains(FirebaseAuth.instance.currentUser!.uid);
          bool newIsLiked = !isLiked;

          List<String> newLikers = List<String>.from(likes);

          if (newIsLiked) {
            newLikers.add(FirebaseAuth.instance.currentUser!.uid);

            await FirebaseFirestore.instance
                .collection(DatabaseCollections.chefs)
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'favorites': FieldValue.arrayUnion([widget.recipeID]),
            });

            final favoriteRecipeDocRef = FirebaseFirestore.instance
                .collection(DatabaseCollections.favoriteRecipes)
                .doc(
                    '${FirebaseAuth.instance.currentUser!.uid}_${widget.recipeID}');

            // Get the current timestamp
            final timestamp = DateTime.now().millisecondsSinceEpoch;

            await favoriteRecipeDocRef.set({
              'recipeId': widget.recipeID,
              'userId': FirebaseAuth.instance.currentUser!.uid,
              'timestamp': DateTime.fromMillisecondsSinceEpoch(timestamp),
            });

            String chefToken = recipeDoc['chefToken'] ?? '';
            if (chefToken.isNotEmpty) {
              final PushNotification pushNotification =
                  PushNotificationImpl(FlutterLocalNotificationsPlugin());

              String notificationTitle =
                  'Hey there, ${FirebaseAuth.instance.currentUser!.displayName} liked your recipe!';

              if (recipeDoc['chefID'] ==
                  FirebaseAuth.instance.currentUser!.uid) {
                // User liked their own recipe
                notificationTitle = 'You liked your own recipe!';
              }

              // Send the notification
              await pushNotification.sendPushNotifs(
                title: notificationTitle,
                body: '',
                token: chefToken,
              );
            }
          } else {
            newLikers.remove(FirebaseAuth.instance.currentUser!.uid);

            // Remove from favoriteRecipes collection
            await FirebaseFirestore.instance
                .collection(DatabaseCollections.favoriteRecipes)
                .doc(
                    '${FirebaseAuth.instance.currentUser!.uid}_${widget.recipeID}')
                .delete();

            // Update favorites array in chef document
            await FirebaseFirestore.instance
                .collection(DatabaseCollections.chefs)
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'favorites': FieldValue.arrayRemove([widget.recipeID]),
            });

            await FirebaseFirestore.instance
                .collection(DatabaseCollections.recipes)
                .doc(widget.recipeID)
                .update({
              'likes': FieldValue.arrayRemove(
                  [FirebaseAuth.instance.currentUser!.uid]),
            });
          }

          await like(
            recipeId: widget.recipeID,
            likers: newLikers,
            context: context,
          );

          // Additional logic for sending notifications if needed
        } catch (e) {
          setState(() {
            _isLiked = !_isLiked;
          });
          SnackBarHelper.showErrorSnackBar(context, e.toString());
        }
      },
      child: Material(
        color: ExtraColors.white,
        shape: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            _isLiked ? IconlyBold.heart : IconlyLight.heart,
            color: _isLiked ? Theme.of(context).primaryColor : ExtraColors.grey,
            size: _isLiked ? 20 : 20,
          ),
        ),
      ),
    );
  }
}
