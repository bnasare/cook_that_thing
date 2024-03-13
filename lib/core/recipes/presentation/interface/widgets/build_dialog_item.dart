import 'package:flutter/material.dart';

class BuildItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const BuildItem({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      onTap: () {
        controller.text = label;
        Navigator.of(context).pop();
      },
    );
  }
}
