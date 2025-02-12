import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';

class UpdateProfileController extends GetxController {

  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile(String email, String firstName, String lastName, String mobile, String password, XFile? pickedImage) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (pickedImage != null) {
      List<int> imageBytes = await pickedImage.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }
    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.updateProfile, body: requestBody);
    _inProgress = false;
    update();
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = 'Profile updated successfully';
    }
    else {
      _errorMessage =  response.errorMessage;
    }
    return isSuccess;
  }
}