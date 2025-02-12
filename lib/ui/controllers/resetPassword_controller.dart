import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  bool _resetPasswordInProgress = false;
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future <bool> postResetPassword(String email, OTP, password) async{
    _resetPasswordInProgress = true;
    update();
    Map <String, dynamic> requestBody = {
      "email": email,
      "OTP" : OTP,
      "password": password,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.resetPasswordUrl, body: requestBody);
    _resetPasswordInProgress = false;
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