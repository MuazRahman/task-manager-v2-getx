import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class SignUpController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  Future <bool> registerUser(String email, String firstName, String lastName, String mobile, String password, String photo) async {
    bool isSuccess = false;
    _inProgress = false;
    update();
    Map <String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo":""
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.registrationUrl, body: requestBody);
    _inProgress = false;
    update();
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage =  'New user registration successful.';
    }
    else {
      _errorMessage =  response.errorMessage;
    }
    return isSuccess;
  }

}