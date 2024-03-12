import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class CustomSearchBox extends HookWidget {
  final void Function(String query) handleSearch;
  final TextEditingController controller;
  final String label;
  final String hintText;
  const CustomSearchBox({
    super.key,
    required this.handleSearch,
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
              // suffixIcon: Clickable(
              // onClick: () => controller.clear(),
              // child: Icon(
              // IconlyLight.close_square,
              // color: Theme.of(context).colorScheme.primary,
              // size: 18,
              // ),
              // ),
              labelText: label,
              labelStyle:
                  const TextStyle(fontSize: 22, color: ExtraColors.black),
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.only(
                  left: 25, right: 25, top: 25, bottom: 10),
              hintText: hintText,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  color: ExtraColors.darkGrey,
                  fontWeight: FontWeight.w500),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: ExtraColors.darkGrey.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: ExtraColors.darkGrey,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              filled: false,
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
