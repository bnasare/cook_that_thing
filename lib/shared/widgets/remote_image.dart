import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../presentation/theme/extra_colors.dart';

class RemoteImage extends StatelessWidget {
  const RemoteImage({
    required this.imageUrl,
    this.hasPlaceholder = true,
    this.iconData,
    this.iconSize,
    this.height,
    this.width,
    this.size,
    super.key,
  });

  final double? size;
  final double? width;
  final double? height;
  final double? iconSize;

  final bool hasPlaceholder;

  final IconData? iconData;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Container circled(Widget? child) {
      return Container(
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(color: Color(0xFFC8E6C9)),
          ),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        height: size ?? height,
        width: size ?? width,
        child: child,
      );
    }

    return CachedNetworkImage(
      placeholder: (_, __) => circled(
        hasPlaceholder
            ? Shimmer.fromColors(
                highlightColor: ExtraColors.white,
                baseColor: const Color(0xFFC8E6C9),
                child: Icon(iconData, size: iconSize),
              )
            : null,
      ),
      errorWidget: (_, __, ___) => circled(
        Icon(
          Icons.error,
          color: const Color(0xFFF48FB1),
          size: iconSize,
        ),
      ),
      imageUrl: imageUrl,
      height: size ?? height,
      width: size ?? width,
      fit: BoxFit.cover,
    );
  }
}
