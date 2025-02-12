import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/recover_verify_otp_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class VerifyOTPController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  RecoverVerifyOTP? recoverVerifyOtp;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getVerifyOTP(String email, otp) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    debugPrint(email);
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.recoverVerifyOTPlUrl(
        email,
        otp,
      ),
    );
    _inProgress = false;
    update();
    if (response.isSuccess) {
      recoverVerifyOtp = RecoverVerifyOTP.fromJson(response.responseData!);
      if (recoverVerifyOtp!.status == 'success') {
        isSuccess = true;
      } else {
        _errorMessage = 'No user found';
      }
    } else {
      _errorMessage =  'Network error. Please try again later';
    }
    return isSuccess;
  }
}
