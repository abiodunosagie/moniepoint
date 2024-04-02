import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Image(
                  height: 60,
                  width: 60,
                  image: AssetImage(
                    TImages.loginLogoLightAndDark,
                  ),
                ),
              ),
              const Spacer(
                flex: 4,
              ),
              Text(
                TTexts.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: dark ? TColors.darkContainerCustom : TColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Login with options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TTexts.loginRow,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: dark
                                      ? TColors.secondary
                                      : TColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Iconsax.call,
                                      color: dark
                                          ? TColors.buttonDisabledDark
                                          : TColors.white,
                                      size: 15,
                                    ),
                                    FittedBox(
                                      child: Text(
                                        TTexts.phoneNo,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontSize: 10,
                                              color: dark
                                                  ? TColors.darkerGrey
                                                  : TColors.white,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: dark
                                      ? TColors.darkerGrey
                                      : TColors.buttonDisabled,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Iconsax.user,
                                      color: dark
                                          ? TColors.white
                                          : TColors.buttonDisabledDark,
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    FittedBox(
                                      child: Text(
                                        TTexts.username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontSize: 10,
                                                color: dark
                                                    ? TColors.lightGrey
                                                    : TColors.darkGrey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Phone number input section
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: dark
                              ? TColors.darkGreyPhone
                              : TColors.buttonDisabled,
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                const Image(
                                  width: 35,
                                  height: 35,
                                  image: AssetImage(
                                    TImages.nigerianFlag,
                                  ),
                                ),
                                const SizedBox(
                                  width: TSizes.spaceBtwItems,
                                ),
                                Text(
                                  '+234',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                        color: TColors.white.withOpacity(0.5),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: TSizes.spaceBtwItems,
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintText: "Phone number",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                          color: dark
                                              ? TColors.darkGrey
                                              : TColors.darkerGrey),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Next button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                dark ? TColors.secondary : TColors.primary,
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          onPressed: () {},
                          child: Text(
                            TTexts.loginButtonText,
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color:
                                    dark ? TColors.darkerGrey : TColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: Text(
                    TTexts.forgetPassword,
                    style: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: dark ? TColors.secondary : TColors.primary,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
