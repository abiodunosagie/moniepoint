import 'package:flutter/material.dart';
import 'package:t_store/utils/constants/text_strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              TTexts.createAccount,
            ),
          ),
        ],
      ),
    );
  }
}
