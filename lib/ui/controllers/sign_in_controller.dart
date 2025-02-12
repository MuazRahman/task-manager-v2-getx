import 'package:get/get.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class SignInController extends GetxController {
  bool _signInProgress = false;
  bool get inProgress => _signInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future <bool> signIn(String email, String password) async{
    bool isSuccess = false;
    _signInProgress = true;
    update();
    Map <String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.loginUrl, body: requestBody);
    if (response.isSuccess) {
      String token = response.responseData!['token'];
      UserModel userModel = UserModel.fromJson(response.responseData!['data']);
      await AuthController.saveUserData(token, userModel);
      // Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
      isSuccess = true;
      _errorMessage = 'Sign in successful';
    }
    else {

      if (response.statusCode == 401) {
        _errorMessage = 'Invalid Email/password! Try again';
      }
      else {
        _errorMessage = response.errorMessage;
      }
    }
    _signInProgress = false;
    update();
    return isSuccess;
  }
}
