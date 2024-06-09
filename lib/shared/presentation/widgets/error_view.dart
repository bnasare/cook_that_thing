import 'package:flutter/material.dart';

import '../../data/image_assets.dart';

class ErrorViewWidget extends StatelessWidget {
  const ErrorViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Image.asset(
          ImageAssets.viewed,
          height: 280,
          width: 280,
        ),
        const SizedBox(height: 30),
        Center(
          child: Text(
            'Nothing to show here...',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
