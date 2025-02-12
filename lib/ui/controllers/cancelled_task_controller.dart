import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class CancelledTaskController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TaskListByStatusModel? _cancelledTaskListByStatusModel;
  List<TaskModel> get taskList => _cancelledTaskListByStatusModel?.taskList ?? [];

  Future <bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Cancelled'));
    if (response.isSuccess) {
      isSuccess = true;
      _cancelledTaskListByStatusModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}