import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class ProgressTaskController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  TaskListByStatusModel? _progressTaskListModel;

  List<TaskModel> get taskList => _progressTaskListModel?.taskList ?? [];

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future <bool> getProgressTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Progress'));
    if (response.isSuccess) {
      isSuccess = true;
      _progressTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}
