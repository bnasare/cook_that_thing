import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_hub/shared/data/svg_assets.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/src/authentication/presentation/interface/pages/login.dart';
import 'package:recipe_hub/src/authentication/presentation/interface/pages/sign_up.dart';
import 'package:recipe_hub/src/onboarding/presentation/bloc/onboarding_mixin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget with OnboardingMixin {
  Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _pageController = PageController();
  List images = [
    SvgAssets.book,
    SvgAssets.female,
    SvgAssets.male,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    List titles = [
      localizations.titleDiscovery,
      localizations.titleExcellence,
      localizations.titleExquisite,
    ];
    List subtitles = [
      localizations.subtitleDiscovery,
      localizations.subtitleExcellence,
      localizations.subtitleExquisite,
    ];

    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        images[index],
                        width: 250,
                        height: 250,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        titles[index],
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          subtitles[index],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: ExtraColors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SmoothPageIndicator(
              controller: _pageController,
              count: images.length,
              effect: JumpingDotEffect(
                activeDotColor: Theme.of(context).primaryColor,
                dotColor: ExtraColors.darkGrey.withOpacity(0.3),
                dotHeight: 13,
                dotWidth: 13,
                spacing: 10,
              )),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                widget.completeOnboardingChecks();
                NavigationHelper.navigateToReplacement(context, LoginPage());
              },
              child: const Text('Log In',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ExtraColors.white,
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                widget.completeOnboardingChecks();
                NavigationHelper.navigateToReplacement(context, SignUpPage());
              },
              child: const Text('Register',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
