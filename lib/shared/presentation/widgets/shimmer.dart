import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/extra_colors.dart';

class LoadingTextView extends StatelessWidget {
  final double? width;
  final double? height;
  const LoadingTextView({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
        direction: ShimmerDirection.ltr,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.error,
            ExtraColors.yellow,
            ExtraColors.black,
          ],
          stops: const [0.1, 0.3, 0.4],
          begin: const Alignment(-1.0, -0.5),
          end: const Alignment(1.0, 0.5),
          tileMode: TileMode.repeated,
        ),
        child: ShimmerSkeleton(width: width, height: height));
  }
}

class LoadingListView extends StatelessWidget {
  const LoadingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: 15,
        itemBuilder: (context, index) {
          return Shimmer(
            direction: ShimmerDirection.ltr,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.error,
                ExtraColors.yellow,
                ExtraColors.black,
              ],
              stops: const [0.1, 0.3, 0.4],
              begin: const Alignment(-1.0, -0.5),
              end: const Alignment(1.0, 0.5),
              tileMode: TileMode.repeated,
            ),
            child: const ShimmerWidget(),
          );
        },
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ShimmerSkeleton(height: 120, width: 120),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerSkeleton(width: 80),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ShimmerSkeleton(),
              ),
              ShimmerSkeleton(),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ShimmerSkeleton(),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ShimmerSkeleton(),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({super.key, this.height, this.width});

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: ExtraColors.black.withOpacity(0.04),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({super.key, this.size = 24});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
