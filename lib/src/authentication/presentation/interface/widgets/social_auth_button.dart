import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class SocialAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final double imageHeight;
  final double imageWidth;
  final String buttonText;
  final double space;

  const SocialAuthButton({
    super.key,
    required this.onPressed,
    required this.imagePath,
    this.imageHeight = 25,
    this.imageWidth = 25,
    this.space = 10,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(right: 0),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: ExtraColors.lightGrey, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage(imagePath),
                height: imageHeight,
                width: imageWidth),
            SizedBox(width: space),
            Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
