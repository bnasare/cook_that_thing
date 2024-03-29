// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../src/profile/presentation/interface/pages/profile.dart';
import '../../../../recipes/presentation/interface/widgets/follow_button.dart';
import '../../../domain/entities/chef.dart';
import '../../bloc/chef_mixin.dart';

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
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ProfilePage(chefID: chef.id);
                  },
                ),
              );
            },
            leading: const Icon(
              CupertinoIcons.person_alt_circle,
              size: 60,
              color: ExtraColors.darkGrey,
            ),
            title: Text(chef.name,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis),
            subtitle: Text(chef.email,
                overflow: TextOverflow.ellipsis, style: const TextStyle()),
            trailing: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: SizedBox(
                width: 115,
                height: 40,
                child: FollowButton(chefID: chef.id),
              ),
            ));
      },
      separatorBuilder: (context, index) =>
          const Divider(color: ExtraColors.lightGrey, thickness: 2),
      itemCount: chefs.length,
    );
  }
}
