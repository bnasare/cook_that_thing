import 'package:flutter/material.dart';

import '../../data/image_assets.dart';
import '../theme/extra_colors.dart';

class WarningModal extends StatelessWidget {
  const WarningModal({
    super.key,
    required this.title,
    required this.content,
    this.primaryButtonLabel,
    this.secondaryButtonLabel,
    this.primaryAction,
    this.secondaryAction,
  });

  final String title;
  final String content;
  final String? primaryButtonLabel;
  final String? secondaryButtonLabel;
  final void Function()? primaryAction;
  final void Function()? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(50)),
      backgroundColor: ExtraColors.white,
      surfaceTintColor: ExtraColors.white,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageAssets.warning,
              height: 80,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.colorScheme.error.withOpacity(0.2),
              ),
              child: Text(
                'Warning',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 15,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: primaryAction != null && primaryButtonLabel != null,
              child: ElevatedButton(
                onPressed: primaryAction,
                style: ElevatedButton.styleFrom(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: theme.colorScheme.error,
                  padding: EdgeInsets.zero,
                  fixedSize: const Size(
                    double.maxFinite,
                    30,
                  ),
                ),
                child: Text(
                  primaryButtonLabel ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: secondaryAction != null && secondaryButtonLabel != null,
              child: ElevatedButton(
                onPressed: secondaryAction,
                style: ElevatedButton.styleFrom(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: const Color(0xFF9E9E9E),
                  padding: EdgeInsets.zero,
                  fixedSize: const Size(
                    double.maxFinite,
                    30,
                  ),
                ),
                child: Text(
                  secondaryButtonLabel ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
