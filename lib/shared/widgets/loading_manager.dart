import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../presentation/theme/extra_colors.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager(
      {super.key, required this.isLoading, required this.child});
  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                color: ExtraColors.black.withOpacity(0.7),
              )
            : Container(),
        isLoading
            ? Center(
                child: SpinKitFadingCube(
                  color: ExtraColors.white.withOpacity(0.4),
                ),
              )
            : Container()
      ],
    );
  }
}
