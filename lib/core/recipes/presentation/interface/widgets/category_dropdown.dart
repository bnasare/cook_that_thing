import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final void Function(String?) onChanged;

  const CategoryDropdown({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Category',
        hintText: 'Select category from dropdown',
      ),
      menuMaxHeight: 100,
      items: const [
        DropdownMenuItem(
          value: 'Breakfast',
          child: Text('Breakfast'),
        ),
        DropdownMenuItem(
          value: 'Lunch',
          child: Text('Lunch'),
        ),
        DropdownMenuItem(
          value: 'Dinner',
          child: Text('Dinner'),
        ),
        DropdownMenuItem(
          value: 'Dessert',
          child: Text('Dessert'),
        ),
        DropdownMenuItem(
          value: 'Vegan',
          child: Text('Vegan'),
        ),
        DropdownMenuItem(
          value: 'Snacks',
          child: Text('Snacks'),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
