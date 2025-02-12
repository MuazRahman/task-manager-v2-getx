import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/reset_password_model.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/sreens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../utils/app_color.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  static const String name = '/forgot-password/reset-password';

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ResetPassword? resetPassword;
  final ResetPasswordController _resetPasswordController = Get.find<ResetPasswordController>();

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
                    'Set Password',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Minimum length of password should be more than 8 letters.',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: _newPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'New Password'
                    ),
                    validator: (String? value) {
                      if(value!.isEmpty && int.parse(value) < 6) {
                          return 'Enter a new password more than 6 letter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(
                        hintText: 'Confirm new Password'
                    ),
                    validator: (String? value) {
                      if(value!.isEmpty && int.parse(value) < 6) {
                        return 'Enter password again';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GetBuilder<ResetPasswordController>(
                    builder: (controller) {
                      return Visibility(
                        visible: controller.inProgress == false, // _resetPasswordInProgress == false,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: () {
                            _onTapResetPasswordButton();
                          },
                          child: const Text('Confirm'),
                        ),
                      );
                    }
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: _buildSignInSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSignInSection() {
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
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (value) => false);
              },
          ),
        ],
      ),
    );
  }

  void _onTapResetPasswordButton() {
    if (_newPasswordTEController.text == _confirmPasswordTEController.text) {
      _postResetPassword();
    } else {
      showSnackBarMessage("Password didn't match");
    }
  }

  Future <void> _postResetPassword() async{
    final isSuccess = await _resetPasswordController.postResetPassword(widget.email, widget.otp, _confirmPasswordTEController.text);
    if (isSuccess) {
      Get.offNamed(SignInScreen.name);
      showSnackBarMessage(_resetPasswordController.errorMessage!);
    }
    else {
      showSnackBarMessage(_resetPasswordController.errorMessage!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
  }
}
