// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../../shared/data/collection_ids.dart';
import '../../../../../shared/platform/push_notification.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../bloc/recipe_mixin.dart';

class FollowButton extends StatefulWidget with RecipeMixin {
  final String chefID;
  final double height;
  final double width;

  FollowButton({
    super.key,
    required this.chefID,
    this.height = 75,
    this.width = 35,
  });

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isCurrentlyFollowing = false;
  StreamSubscription<DocumentSnapshot>? _chefDocSubscription;

  @override
  void initState() {
    super.initState();
    _updateFollowStatus();
  }

  Future<void> _updateFollowStatus() async {
    Stream<DocumentSnapshot> chefDocStream = FirebaseFirestore.instance
        .collection(DatabaseCollections.chefs)
        .doc(widget.chefID)
        .snapshots();

    _chefDocSubscription = chefDocStream.listen((chefDoc) {
      if (chefDoc.exists) {
        List<dynamic> followers = chefDoc['followers'] ?? [];
        if (mounted) {
          setState(() {
            _isCurrentlyFollowing =
                followers.contains(FirebaseAuth.instance.currentUser!.uid);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _chefDocSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        if (_isCurrentlyFollowing) {
          await unfollow();
        } else {
          await follow();
          DocumentSnapshot chefDoc = await FirebaseFirestore.instance
              .collection(DatabaseCollections.chefs)
              .doc(widget.chefID)
              .get();

          String chefToken = chefDoc['chefToken'] ?? '';
          if (chefToken.isEmpty) {
            return;
          }

          if (chefDoc['chefID'] == FirebaseAuth.instance.currentUser?.uid) {
            return;
          }

          final PushNotification pushNotification =
              PushNotificationImpl(FlutterLocalNotificationsPlugin());

          await pushNotification.sendPushNotifs(
            title:
                'Hey there, ${FirebaseAuth.instance.currentUser?.displayName} is following you!',
            body: '',
            token: chefToken,
          );
        }
        await _updateFollowStatus();
      },
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        fixedSize: Size(widget.height, widget.width),
      ),
      child: Center(
        child: Text(
          _isCurrentlyFollowing ? 'Unfollow' : 'Follow',
          style: const TextStyle(
            fontSize: 16,
            color: ExtraColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> follow() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await widget.follow(
        context: context,
        chefId: widget.chefID,
        followers: [FirebaseAuth.instance.currentUser!.uid],
        token: [token ?? '']);
  }

  Future<void> unfollow() async {
    await widget.follow(
        context: context, chefId: widget.chefID, followers: [], token: []);
  }
}
