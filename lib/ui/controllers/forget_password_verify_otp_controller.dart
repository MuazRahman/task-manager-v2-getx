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

  Future<bool> getVerifyOTP(String email, OTP) async {
    bool isSuccess = false;
    // String? mail = email;
    _inProgress = true;
    update();
    print(email);
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.recoverVerifyOTPlUrl(
        email,
        OTP,
      ),
    );
    _inProgress = false;
    update();
    if (response.isSuccess) {
      recoverVerifyOtp = RecoverVerifyOTP.fromJson(response.responseData!);
      if (recoverVerifyOtp!.status == 'success') {
        // Navigator.pushNamed(context, ResetPasswordScreen.name);
        isSuccess = true;
        String otp = OTP;
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ResetPasswordScreen(
        //           email: widget.email,
        //           otp: otp,
        //         )));
      } else {
        _errorMessage = 'No user found';
      }
    } else {
      _errorMessage =  'Network error. Please try again later';
    }
    return isSuccess;
  }
}
