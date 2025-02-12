import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/recover_verify_email_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class VerifyMailController extends GetxController {

  bool _signInProgress = false;
  bool get inProgress => _signInProgress;
  RecoverVerifyEmail? recoverVerifyEmail;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getVerifyMail(String email) async {
    String mail = email;
    bool isSuccess = false;
    _signInProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyEmailUrl(mail));
    _signInProgress = false;
    update();

    if (response.isSuccess) {
      recoverVerifyEmail = RecoverVerifyEmail.fromJson(response.responseData!);
      if (recoverVerifyEmail!.status == 'success') {
        String email = mail;
        debugPrint("Email is => $email");
        isSuccess = true;
        // Navigator.to(context, ForgotPasswordVerifyOtpScreen.name, arguments: email);
      }
      else {
        _errorMessage =  'No user found';
      }
    }
    else {
      _errorMessage =  'Network error. Please try again later';
    }
    return isSuccess;
  }
}