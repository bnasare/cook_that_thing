import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';

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
          tileColor: Theme.of(context).colorScheme.primaryContainer,
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
            size: 45,
            color: ExtraColors.darkGrey,
          ),
          title: Text(chef.name,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(chef.email),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: chefs.length,
    );
  }
}
