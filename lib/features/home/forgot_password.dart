import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

void _launchPhone(String phoneNumber) async {
  String url = 'tel:$phoneNumber';
  Uri uri = Uri.parse(url); // Parse the URL string into a Uri object
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch $url';
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: dark ? TColors.white : TColors.darkerGrey,
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          TTexts.usernameRecovery,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TTexts.usernameRecovery,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Text(
              TTexts.usernameSubTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: dark ? TColors.darkContainerCustom : TColors.white,
              ),
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: dark
                        ? TColors.darkGreyContainer
                        : TColors.buttonDisabled,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.zero),
                          ),
                          onPressed: () => _launchPhone('*5573*73*1#'),
                          child: Text(
                            TTexts.recoveryPhoneDial,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .apply(
                                  color: dark
                                      ? TColors.secondary
                                      : TColors.primary,
                                ),
                          ),
                        ),
                        const Icon(
                          Iconsax.keyboard,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark ? TColors.secondary : TColors.primary,
                  side: const BorderSide(color: Colors.transparent),
                ),
                onPressed: () {},
                child: Text(
                  TTexts.loginButtonText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: dark ? TColors.darkerGrey : TColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
