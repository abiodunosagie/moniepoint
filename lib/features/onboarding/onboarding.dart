import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/home/login.dart';
import 'package:t_store/features/home/sign_up.dart';
import 'package:t_store/features/onboarding/widgets/dot_navigation.dart';
import 'package:t_store/features/onboarding/widgets/onboarding_page.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../utils/constants/image_strings.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                children: [
                  // logo
                  Container(
                    alignment: Alignment.center,
                    child: Image(
                      width: 150,
                      height: 100,
                      image: AssetImage(
                        dark
                            ? TImages.spotifyLogoDark
                            : TImages.spotifyLogoLight,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.updatePageIndicator,
                      children: const [
                        OnboardingPage(
                          image: TImages.vibesBoy,
                          title: TTexts.onBoardingTitle1,
                          subTitle: TTexts.onBoardingSubTitle1,
                        ),
                        OnboardingPage(
                          image: TImages.vibesMan,
                          title: TTexts.onBoardingTitle2,
                          subTitle: TTexts.onBoardingSubTitle2,
                        ),
                        OnboardingPage(
                          image: TImages.equalizerGreen,
                          title: TTexts.onBoardingTitle3,
                          subTitle: TTexts.onBoardingSubTitle3,
                        ),
                        OnboardingPage(
                          image: TImages.musicDropDown,
                          title: TTexts.onBoardingTitle4,
                          subTitle: TTexts.onBoardingSubTitle4,
                        ),
                        OnboardingPage(
                          image: TImages.speakerAnimation,
                          title: TTexts.onBoardingTitle5,
                          subTitle: TTexts.onBoardingSubTitle5,
                        ),
                      ],
                    ),
                  ),

                  /// dot navigation
                  const OnboardingDotNavigation(),
                  const SizedBox(
                    height: TSizes.defaultSpace * 2,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  // Fixed buttons at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle login button press
                            Get.off(() => const LoginScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dark
                                ? TColors.buttonDisabledDark
                                : TColors.buttonDisabled,
                            side: BorderSide(
                                color: dark
                                    ? TColors.buttonDisabledDark
                                    : TColors.buttonDisabled),
                          ),
                          child: Text(
                            TTexts.signIn,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(
                                    color: dark
                                        ? TColors.secondary
                                        : TColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: TSizes.spaceBtwItems,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle signup button press
                            Get.off(() => const SignUpScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                dark ? TColors.secondary : TColors.primary,
                            side: BorderSide(
                              color: dark ? TColors.secondary : TColors.primary,
                            ),
                          ),
                          child: Text(
                            TTexts.createAccount,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(
                                    color: dark
                                        ? TColors.buttonDisabledDark
                                        : TColors.white),
                          ),
                        ),
                      ),
                    ],
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
