import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:t_store/features/onboarding/onboarding_controller.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return SmoothPageIndicator(
      controller: controller.pageController,
      onDotClicked: controller.dotNavigationClick,
      count: 5,
      effect: ExpandingDotsEffect(
        activeDotColor: dark ? TColors.secondary : TColors.primary,
        dotColor: dark ? TColors.dotNavigationDark : TColors.buttonDisabled,
        dotHeight: 6,
        dotWidth: 5,
      ),
    );
  }
}
