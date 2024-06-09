import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../theme/extra_colors.dart';

class SnackBarHelper {
  static void showSuccessSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      IconlyBold.shield_done,
      const Color(0xFF4CAF50),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      IconlyBold.info_circle,
      const Color(0xFF29B6F6),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      IconlyBold.shield_fail,
      const Color(0xFFE53935),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      IconlyBold.time_square,
      const Color(0xFFFFB300),
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
        dismissType: DismissType.onSwipe,
        safeAreaValues: const SafeAreaValues(top: true),
        CustomSnackBar.success(
          message: message,
          messagePadding: const EdgeInsets.symmetric(horizontal: 15),
          borderRadius: BorderRadius.circular(12),
          backgroundColor: backgroundColor,
          iconRotationAngle: 0,
          iconPositionLeft: 20,
          iconPositionTop: -10,
          maxLines: 5,
          textAlign: TextAlign.center,
          textStyle: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w200,
            color: ExtraColors.white,
            fontSize: 13,
          ),
        ),
        persistent: persist,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        curve: Curves.elasticOut,
        animationDuration: const Duration(seconds: 2),
        displayDuration: const Duration(seconds: 6));
  }
}
