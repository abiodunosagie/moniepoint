import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/home/login.dart';
import 'package:t_store/features/home/sign_up.dart';
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
                        dark ? TImages.darkAppLogo : TImages.lightAppLogo,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.updatePageIndicator,
                      children: const [
                        OnboardingPage(
                          image: TImages.onBoardingImage1,
                          title: TTexts.onBoardingTitle1,
                          subTitle: TTexts.onBoardingSubTitle1,
                        ),
                        OnboardingPage(
                          image: TImages.onBoardingImage2,
                          title: TTexts.onBoardingTitle2,
                          subTitle: TTexts.onBoardingSubTitle2,
                        ),
                        OnboardingPage(
                          image: TImages.onBoardingImage3,
                          title: TTexts.onBoardingTitle3,
                          subTitle: TTexts.onBoardingSubTitle3,
                        ),
                        OnboardingPage(
                          image: TImages.onBoardingImage4,
                          title: TTexts.onBoardingTitle4,
                          subTitle: TTexts.onBoardingSubTitle4,
                        ),
                        OnboardingPage(
                          image: TImages.onBoardingImage5,
                          title: TTexts.onBoardingTitle5,
                          subTitle: TTexts.onBoardingSubTitle5,
                        ),
                      ],
                    ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
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
