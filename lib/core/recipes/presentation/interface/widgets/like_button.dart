// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/shared/data/collection_ids.dart';

import '../../../../../shared/platform/push_notification.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/clickable.dart';
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
    DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
        .collection(DatabaseCollections.recipes)
        .doc(widget.recipeID)
        .get();

    List<dynamic> likes = recipeDoc['likes'] ?? [];
    bool isLiked = likes.contains(FirebaseAuth.instance.currentUser!.uid);

    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onClick: () async {
        DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
            .collection(DatabaseCollections.recipes)
            .doc(widget.recipeID)
            .get();

        List<dynamic> likes = recipeDoc['likes'] ?? [];
        bool isLiked = likes.contains(FirebaseAuth.instance.currentUser!.uid);

        List<String> newLikers = List<String>.from(likes);
        if (!isLiked) {
          newLikers.add(FirebaseAuth.instance.currentUser!.uid);

          await like(
              recipeId: widget.recipeID, likers: newLikers, context: context);

          String chefToken = recipeDoc['chefToken'] ?? '';
          if (chefToken.isNotEmpty) {
            final PushNotification pushNotification =
                PushNotificationImpl(FlutterLocalNotificationsPlugin());

            // Send the notification
            await pushNotification.sendPushNotifs(
              title:
                  'Hey there, ${FirebaseAuth.instance.currentUser!.displayName} liked your recipe!',
              body: '',
              token: chefToken,
            );
          }
        } else {
          newLikers.remove(FirebaseAuth.instance.currentUser!.uid);

          await like(
              recipeId: widget.recipeID, likers: newLikers, context: context);
        }

        if (mounted) {
          setState(() {
            _isLiked = !isLiked;
          });
        }
      },
      child: Material(
        color: ExtraColors.white.withOpacity(0.9),
        shape: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            _isLiked ? IconlyBold.heart : IconlyLight.heart,
            color: _isLiked ? Theme.of(context).primaryColor : ExtraColors.grey,
            size: _isLiked ? 22 : 20,
          ),
        ),
      ),
    );
  }
}
