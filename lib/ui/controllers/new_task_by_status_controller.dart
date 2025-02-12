import 'package:get/get.dart';
import 'package:task_manager/data/models/task_count_by_status_model.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class NewTaskController extends GetxController {
  bool _getTaskCountByStatusInProgress = false;
  bool get getTaskCountByStatusInProgress => _getTaskCountByStatusInProgress;

  TaskCountByStatusModel? _taskCountByStatusModel;
  TaskCountByStatusModel get taskCountByStatusModel => _taskCountByStatusModel?? TaskCountByStatusModel(taskByStatusList: []);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future <bool> getTaskCountByStatus() async {
    bool isSuccess = false;
    _getTaskCountByStatusInProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
    if (response.isSuccess) {
      _taskCountByStatusModel = TaskCountByStatusModel.fromJson(response.responseData!);
      // First call the TaskCount API then call NewTask API
      getTaskList();
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getTaskCountByStatusInProgress = false;
    update();
    return isSuccess;
  }

  bool _getTaskListInProgress = false;
  bool get getTaskListInProgress => _getTaskListInProgress;

  TaskListByStatusModel? _taskListByStatusModel;
  List<TaskModel> get taskList => _taskListByStatusModel?.taskList ?? [];

  Future<void> getTaskList() async {
    _getTaskListInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('New'));
    if (response.isSuccess) {
      _taskListByStatusModel =
          TaskListByStatusModel.fromJson(response.responseData!);
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getTaskListInProgress = false;
    update();
  }
}
