import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  Future <bool> postResetPassword(String email, otp, password) async{
    _inProgress = true;
    update();
    Map <String, dynamic> requestBody = {
      "email": email,
      "OTP" : otp,
      "password": password,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.resetPasswordUrl, body: requestBody);
    _inProgress = false;
    update();
    if (response.isSuccess) {
      _isSuccess = true;
      _errorMessage = 'Password Changed Successfully';
    }
    else {
      _errorMessage = response.errorMessage;
    }
    return isSuccess;
  }
}