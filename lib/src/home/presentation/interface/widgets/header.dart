import 'package:flutter/material.dart';

import '../../../../../shared/widgets/clickable.dart';

class Header extends StatelessWidget {
  final String leading;
  final String? trailing;
  final VoidCallback? onClick;
  const Header({super.key, required this.leading, this.trailing, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leading,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Clickable(
            onClick: onClick ?? () {},
            child: Text(
              trailing?.trim() ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
