// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../bloc/recipe_mixin.dart';

class FollowButton extends HookWidget with RecipeMixin {
  final String chefID;
  final double? height;
  final double? width;
  final double? fontSize;
  FollowButton(this.height, this.width, this.fontSize,
      {super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chefs')
          .doc(chefID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          DocumentSnapshot chefDoc = snapshot.data!;
          List<dynamic> followers = chefDoc['followers'] ?? [];
          bool isCurrentlyFollowing =
              followers.contains(FirebaseAuth.instance.currentUser!.uid);
          return InkWell(
            onTap: () async {
              if (isCurrentlyFollowing) {
                await follow(
                    context: context, chefId: chefID, followers: [], token: []);
              } else {
                String? token = await FirebaseMessaging.instance.getToken();
                await follow(
                    context: context,
                    chefId: chefID,
                    followers: [FirebaseAuth.instance.currentUser!.uid],
                    token: [token ?? '']);
              }
            },
            child: Container(
              height: height ?? 35,
              width: width ?? 75,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(color: ExtraColors.darkGrey),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  isCurrentlyFollowing ? 'Unfollow' : 'Follow',
                  style: TextStyle(
                      fontSize: fontSize ?? 13, color: ExtraColors.white),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
