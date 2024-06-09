import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../data/image_assets.dart';
import '../theme/extra_colors.dart';

class FullscreenDialog extends HookWidget {
  const FullscreenDialog({
    super.key,
    required this.title,
    this.illustration,
    this.content,
    this.primaryButtonLabel,
    this.secondaryButtonLabel,
    this.dialogType = DialogType.info,
    this.canPop = true,
    this.primaryAction,
    this.secondaryAction,
    this.primaryFutureAction,
    this.secondaryFutureAction,
  }) : assert(
          !(primaryAction != null && primaryButtonLabel == null) &&
              !(secondaryAction != null && secondaryButtonLabel == null),
          'You cannot assign an action to a button without a label',
        );

  final String title;
  final String? illustration;
  final String? content;
  final String? primaryButtonLabel;
  final String? secondaryButtonLabel;
  final DialogType dialogType;

  final bool canPop;

  final void Function()? primaryAction;
  final void Function()? secondaryAction;

  final Future<void> Function()? primaryFutureAction;
  final Future<void> Function()? secondaryFutureAction;

  @override
  Widget build(BuildContext context) {
    /// Do not assign a synchronous and an asynchronous function to the same button.
    ///
    /// If you need to do such a thing, put all those actions together in the asynchronous function.
    assert(!(primaryAction != null && primaryFutureAction != null),
        'You cannot assign both an action and a future action to the primary button.');
    assert(!(secondaryAction != null && secondaryFutureAction != null),
        'You cannot assign both an action and a future action to the secondary button.');

    final theme = Theme.of(context);

    final primaryFutureLoading = useState<bool>(false);
    final secondaryFutureLoading = useState<bool>(false);
    final disableButtons = useState<bool>(false);

    useEffect(() {
      disableButtons.value =
          primaryFutureLoading.value || secondaryFutureLoading.value;
      return null;
    }, [primaryFutureLoading.value, secondaryFutureLoading.value]);

    Color retrieveColor() {
      switch (dialogType) {
        case DialogType.info:
          return ExtraColors.black;
        case DialogType.warning:
          return const Color(0xFFFFC107).withOpacity(0.8);
        case DialogType.error:
          return const Color(0xFFDB4F48);
        case DialogType.success:
          return const Color(0xFF65C97A);
        case DialogType.loading:
          return ExtraColors.lightGrey;
      }
    }

    String retrieveDefaultSvg() {
      switch (dialogType) {
        case DialogType.info:
          return ImageAssets.info;
        case DialogType.success:
          return ImageAssets.success;
        case DialogType.warning:
          return ImageAssets.warning;
        case DialogType.error:
          return ImageAssets.error;
        case DialogType.loading:
          return ImageAssets.error;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Color(0x63000000)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Visibility(
              visible: illustration == null && dialogType != DialogType.loading,
              replacement: CupertinoActivityIndicator(
                radius: 20,
                color: theme.colorScheme.primary,
              ),
              child: Image.asset(
                illustration ?? retrieveDefaultSvg(),
                height: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            if (content != null)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  content!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ExtraColors.grey,
                  ),
                ),
              ),
            const Spacer(),
            if (primaryButtonLabel != null)
              ElevatedButton(
                onPressed: disableButtons.value
                    ? null
                    : () async {
                        if (primaryAction != null) {
                          primaryAction!();
                        }
                        if (primaryFutureAction != null) {
                          primaryFutureLoading.value = true;
                          await primaryFutureAction!();
                          primaryFutureLoading.value = false;
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: retrieveColor(),
                ),
                child: primaryFutureLoading.value
                    ? LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: [retrieveColor()],
                      )
                    : Text(primaryButtonLabel!),
              ),
            if (secondaryButtonLabel != null)
              Center(
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: disableButtons.value
                          ? null
                          : () async {
                              if (secondaryAction != null) {
                                secondaryAction!();
                              }
                              if (secondaryFutureAction != null) {
                                secondaryFutureLoading.value = true;
                                await secondaryFutureAction!();
                                secondaryFutureLoading.value = false;
                              }
                            },
                      child: secondaryFutureLoading.value
                          ? const SizedBox(
                              width: 30,
                              height: 15,
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [ExtraColors.black],
                              ),
                            )
                          : Text(
                              secondaryButtonLabel!,
                              style: TextStyle(
                                color: disableButtons.value
                                    ? ExtraColors.grey.withOpacity(0.5)
                                    : null,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum DialogType {
  info,
  error,
  success,
  warning,
  loading,
}
