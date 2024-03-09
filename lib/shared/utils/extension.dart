import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../presentation/theme/theme.dart';

extension CustomElevatedButtonExtension on ElevatedButton {
  ElevatedButton withLoadingState({
    required VoidCallback? onPressed,
    required String text,
    bool loading = false,
  }) {
    return ElevatedButton(
      onPressed: (loading || onPressed == null) ? null : onPressed,
      child: loading
          ? LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [lightColorScheme.primary],
            )
          : Text(text),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

bool compareMaps(Map<dynamic, dynamic> map1, Map<dynamic, dynamic> map2) {
  if (map1.length != map2.length) {
    return false;
  }
  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) {
      return false;
    }
  }
  return true;
}
