import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_count_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/controllers/new_task_by_status_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../widgets/screen_background.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/task_status_summary_counter_widget.dart';
import '../widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  final NewTaskController _newTaskController = Get.find<NewTaskController>();

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: RefreshIndicator(
          onRefresh: _getTaskCountByStatus,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildTasksSummaryByStatus(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GetBuilder<NewTaskController>(
                    builder: (controller) {
                      return GetBuilder<NewTaskController>(
                        builder: (controller) {
                          return Visibility(
                              visible: controller.getTaskListInProgress == false,
                              replacement: const CenteredCircularProgressIndicator(),
                              child: _buildTaskListView(controller.taskList));
                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.pushNamed(context, AddNewTaskScreen.name,);
          if (result != null && result == true) {
            _getTaskCountByStatus();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskListView(List<TaskModel> taskList) {
    if (taskList.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2, // Adjust height for AppBar and other elements
        child: const Center(
          child: Text(
            'No New tasks available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: taskList.length,
      itemBuilder: (context, index) {

          return TaskItemWidget(
            taskModel: taskList[index],
            onDelete: _getTaskCountByStatus,
            onStatusChanged: _getTaskCountByStatus,
          );
      },
    );
  }

  Widget _buildTasksSummaryByStatus() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GetBuilder<NewTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getTaskCountByStatusInProgress == false,
            replacement: const CenteredCircularProgressIndicator(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: controller.taskCountByStatusModel.taskByStatusList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final TaskCountModel model = controller.taskCountByStatusModel.taskByStatusList?[index] ?? TaskCountModel();
                      return TaskStatusSummaryCounterWidget(
                        count: model.sum.toString(),
                        title: model.sId ?? '',
                      );
                    }
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future <void> _getTaskCountByStatus() async {
    final bool isSuccess = await _newTaskController.getTaskCountByStatus();
    // final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
    if (!isSuccess) {
      showSnackBarMessage(context, _newTaskController.errorMessage!);
    }
  }
}
