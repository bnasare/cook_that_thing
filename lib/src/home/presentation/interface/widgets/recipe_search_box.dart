import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconly/iconly.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class CustomSearchBox extends HookWidget {
  final void Function(String query) handleSearch;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Color fillColor;
  const CustomSearchBox({
    super.key,
    required this.handleSearch,
    this.fillColor = ExtraColors.lightGrey,
    required this.controller,
    required this.label,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            maxLines: 1,
            onChanged: handleSearch,
            controller: controller,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: 25, right: 25, top: 15, bottom: 10),
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                IconlyLight.search,
                color: Theme.of(context).primaryColor,
                size: 25,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(13)),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 18,
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
