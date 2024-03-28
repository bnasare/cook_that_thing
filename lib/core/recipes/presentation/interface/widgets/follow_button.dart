// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/data/collection_ids.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../bloc/recipe_mixin.dart';

class FollowButton extends StatefulWidget with RecipeMixin {
  final String chefID;

  FollowButton({
    super.key,
    required this.chefID,
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
        }
        await _updateFollowStatus();
      },
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(75, 35),
      ),
      child: Center(
        child: Text(
          _isCurrentlyFollowing ? 'Unfollow' : 'Follow',
          style: const TextStyle(
            fontSize: 15,
            color: ExtraColors.white,
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
