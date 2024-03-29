import 'package:flutter/material.dart';

import '../../../../../shared/data/image_assets.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../authentication/presentation/interface/pages/login.dart';
import '../../bloc/onboarding_mixin.dart';

class Onboarding extends StatefulWidget with OnboardingMixin {
  Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Image(
            image: AssetImage(ImageAssets.getStarted),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ExtraColors.black,
                  ExtraColors.transparent,
                ],
                stops: [
                  0.2,
                  1,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 16,
                16,
                MediaQuery.of(context).padding.bottom + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  "Explore &\nCreate Amazing Dishes",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: ExtraColors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Unlock over 1200 culinary recipes at your fingertips and bring them to life effortlessly!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ExtraColors.white),
                ),
                const SizedBox(height: 32),
                InkWell(
                  onTap: () async {
                    widget.completeOnboardingChecks();
                    NavigationHelper.navigateToReplacement(
                        context, LoginPage());
                  },
                  child: Container(
                    height: 66,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Get Started",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: ExtraColors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
