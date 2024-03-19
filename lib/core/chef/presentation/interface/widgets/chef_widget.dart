// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/chef/presentation/bloc/chef_mixin.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';

import '../../../../../shared/data/firebase_constants.dart';
import '../../../../../src/profile/presentation/interface/pages/profile.dart';
import '../../../domain/entities/chef.dart';

class ChefWidget extends HookWidget with ChefMixin {
  final List<Chef> chefs;
  ChefWidget({super.key, required this.chefs});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Chef chef = chefs[index];
        return ListTile(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 5,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(chefID: chef.id),
                ),
              );
            },
            leading: const Icon(
              CupertinoIcons.person_alt_circle_fill,
              size: 50,
              color: ExtraColors.darkGrey,
            ),
            title: Text(chef.name,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis),
            subtitle: Text(chef.email,
                style: const TextStyle(
                  height: -2.39,
                  overflow: TextOverflow.ellipsis,
                )),
            trailing: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chefs')
                  .doc(chef.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  DocumentSnapshot chefDoc = snapshot.data!;
                  List<dynamic> followers = chefDoc['followers'] ?? [];
                  bool isCurrentlyFollowing =
                      followers.contains(FirebaseConsts.currentUser!.uid);
                  return InkWell(
                    onTap: () async {
                      if (isCurrentlyFollowing) {
                        await follow(
                            context: context,
                            chefId: chef.id,
                            followers: [],
                            token: []);
                      } else {
                        String? token =
                            await FirebaseMessaging.instance.getToken();
                        await follow(
                            context: context,
                            chefId: chef.id,
                            followers: [FirebaseConsts.currentUser!.uid],
                            token: [token ?? '']);
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 85,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          isCurrentlyFollowing ? 'Unfollow' : 'Follow',
                          style: const TextStyle(
                              fontSize: 15, color: ExtraColors.white),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ));
      },
      separatorBuilder: (context, index) =>
          const Divider(color: ExtraColors.lightGrey, thickness: 2),
      itemCount: chefs.length,
    );
  }
}
