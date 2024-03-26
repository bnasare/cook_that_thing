import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../presentation/theme/extra_colors.dart';

class SnackBarHelper {
  static void showSuccessSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      IconlyBold.shield_done,
      const Color(0xFF50C878),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      IconlyBold.info_circle,
      const Color(0xFFEEA888),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      IconlyBold.shield_fail,
      const Color(0xFFe58282),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      IconlyBold.time_square,
      const Color(0xFFFFA000),
    );
  }

  static void _showCustomSnackBar(
    BuildContext context,
    String message,
    IconData iconData,
    Color backgroundColor, {
    bool persist = false,
  }) {
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: message,
          messagePadding: const EdgeInsets.symmetric(horizontal: 10),
          borderRadius: BorderRadius.zero,
          backgroundColor: backgroundColor,
          iconRotationAngle: 0,
          iconPositionLeft: 40,
          iconPositionTop: -6.8,
          maxLines: 5,
          textAlign: TextAlign.start,
          textStyle: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w200,
            color: ExtraColors.white,
            fontSize: 15,
          ),
        ),
        persistent: persist,
        padding: EdgeInsets.zero,
        curve: Curves.ease,
        animationDuration: const Duration(seconds: 1),
        displayDuration: const Duration(seconds: 5));
  }
}
