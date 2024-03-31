import 'package:flutter/material.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'dot_navigation.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });
  final String image, title, subTitle;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// slide image
        Container(
          margin: const EdgeInsets.all(10),
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  image,
                ),
              ),
              borderRadius: BorderRadius.circular(20),
              color: dark ? TColors.dark : TColors.white),
        ),
        // Text for onboarding
        const SizedBox(
          height: TSizes.defaultSpace,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),

        const SizedBox(
          height: TSizes.defaultSpace,
        ),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: TSizes.defaultSpace,
        ),

        /// dot navigation
        const OnboardingDotNavigation(),
        const SizedBox(
          height: TSizes.defaultSpace * 2,
        ),
      ],
    );
  }
}
