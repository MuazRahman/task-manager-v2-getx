import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/complete_task_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../widgets/screen_background.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/tm_app_bar.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() =>
      _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _getCompletedTaskListInProgress = false;
  TaskListByStatusModel? completedTaskListModel;
  final CompleteTaskController _completeTaskController = Get.find<CompleteTaskController>();

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: RefreshIndicator(
          onRefresh: _getCompletedTaskList,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GetBuilder<CompleteTaskController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.inProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: _buildTaskListView(),);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    if (completedTaskListModel?.taskList?.isEmpty ?? true) {
      return const Center(
        child: Text(
          'No completed tasks available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: completedTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: completedTaskListModel!.taskList![index],
          onDelete: _getCompletedTaskList,
          onStatusChanged: _getCompletedTaskList,
        );
      },
    );
  }


  Future <void> _getCompletedTaskList() async {
    final isSuccess = await _completeTaskController.getCompletedTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _completeTaskController.errorMessage!);
    }
  }
}
