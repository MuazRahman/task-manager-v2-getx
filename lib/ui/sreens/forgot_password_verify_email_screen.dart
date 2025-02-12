import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/recover_verify_email_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/forget_password_verify_email_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../utils/app_color.dart';
import '../widgets/screen_background.dart';
import 'forgot_password_verify_otp_screen.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  static const String name = '/forgot-password/verify-email';

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _getVerifyEmailInProgress = false;
  RecoverVerifyEmail? recoverVerifyEmail;
  final VerifyMailController _verifyMailController = Get.find<VerifyMailController>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Your email address',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'A 6 digit of OTP will be sent to your email address',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GetBuilder<VerifyMailController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !_getVerifyEmailInProgress,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: () {
                            _onTapVerifyEmailButton();
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: _buildSignInSection(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapVerifyEmailButton() {
    if (_formKey.currentState!.validate()) {
      _getVerifyMail();
    }
  }

  Future<void> _getVerifyMail() async {
    final isSuccess = await _verifyMailController.getVerifyMail(_emailTEController.text.trim());
    if (isSuccess) {
        // Navigator.to(context, ForgotPasswordVerifyOtpScreen.name, arguments: email);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordVerifyOtpScreen(email: _emailTEController.text.trim())));
      }
      else {
        showSnackBarMessage(context, _verifyMailController.errorMessage!);
      }
    }
  }


  Widget _buildSignInSection(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Have an account?  ",
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(
              color: AppColor.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
          ),
        ],
      ),
    );
  }

