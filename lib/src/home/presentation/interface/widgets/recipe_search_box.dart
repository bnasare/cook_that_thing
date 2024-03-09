import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconly/iconly.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class RecipeSearchBox extends HookWidget {
  final void Function(String query) handleSearch;
  final TextEditingController controller;
  final bool readOnly;
  const RecipeSearchBox(
      {super.key,
      required this.handleSearch,
      required this.controller,
      required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            maxLines: 1,
            onChanged: handleSearch,
            readOnly: readOnly,
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: ExtraColors.lightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                IconlyLight.search,
                color: ExtraColors.darkGrey,
                size: 18,
              ),
              hintText: 'Search',
              hintStyle: const TextStyle(
                color: ExtraColors.darkGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        // const SizedBox(width: 10),
        // Container(
        // height: 43,
        // width: 43,
        // decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.primary,
        // borderRadius: BorderRadius.circular(10),
        // ),
        // child: Icon(
        // IconlyLight.filter,
        // color: Theme.of(context).colorScheme.onPrimary,
        // ),
        // ),
      ],
    );
  }
}
