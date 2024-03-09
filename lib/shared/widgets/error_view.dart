import 'package:flutter/material.dart';

import '../data/image_assets.dart';

class ErrorViewWidget extends StatelessWidget {
  const ErrorViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Image.asset(
            ImageAssets.viewed,
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Nothing to show here...',
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
