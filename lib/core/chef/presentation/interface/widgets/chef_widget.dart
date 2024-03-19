import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/src/profile/presentation/interface/widgets/follow_button.dart';

import '../../../../../src/profile/presentation/interface/pages/profile.dart';
import '../../../domain/entities/chef.dart';

class ChefWidget extends StatelessWidget {
  final List<Chef> chefs;
  const ChefWidget({super.key, required this.chefs});

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
            trailing: FollowButton(35, 85, 15, chefID: chef.id));
      },
      separatorBuilder: (context, index) =>
          const Divider(color: ExtraColors.lightGrey, thickness: 2),
      itemCount: chefs.length,
    );
  }
}
