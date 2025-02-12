import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class AddNewTaskController extends GetxController {
  bool _addNewTaskInProgress = false;
  bool get inProgress => _addNewTaskInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> createNewTask(String title, description) async{
    bool isSuccess = false;
    _addNewTaskInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": "New"
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.createTaskUrl, body: requestBody);
    _addNewTaskInProgress = false;
    update();
    if (response.isSuccess) {
      _errorMessage = 'New task added!';
      Get.back(result: true);
    }
    else {
      _errorMessage = response.errorMessage;
    }
    return isSuccess;
  }
}