import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class CustomSearchBox extends StatefulWidget {
  final void Function(String query) handleSearch;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool readOnly;
  final bool enabled;
  final Color fillColor;
  final Duration debounceDuration;

  const CustomSearchBox({
    super.key,
    required this.handleSearch,
    this.fillColor = ExtraColors.lightGrey,
    this.readOnly = false,
    this.enabled = true,
    required this.controller,
    required this.label,
    required this.hintText,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  _CustomSearchBoxState createState() => _CustomSearchBoxState();
}

class _CustomSearchBoxState extends State<CustomSearchBox> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.handleSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            maxLines: 1,
            onChanged: _handleSearch,
            controller: widget.controller,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: 25, right: 25, top: 15, bottom: 10),
              filled: true,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                IconlyLight.search,
                color: Theme.of(context).primaryColor,
                size: 25,
              ),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        widget.controller.clear();
                        widget.handleSearch('');
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: const Icon(
                        IconlyBold.close_square,
                        color: ExtraColors.grey,
                      ),
                    )
                  : null,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(13)),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: ExtraColors.darkGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
