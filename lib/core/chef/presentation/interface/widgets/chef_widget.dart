// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:recipe_hub/core/chef/presentation/bloc/chef_mixin.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/follow_button.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';

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
              CupertinoIcons.person_alt_circle,
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
            trailing: SizedBox(
              width: 115,
              height: 40,
              child: FollowButton(chefID: chef.id),
            ));
      },
      separatorBuilder: (context, index) =>
          const Divider(color: ExtraColors.lightGrey, thickness: 2),
      itemCount: chefs.length,
    );
  }
}
