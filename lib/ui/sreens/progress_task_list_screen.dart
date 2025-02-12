import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../widgets/screen_background.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/tm_app_bar.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {

  bool _getProgressTaskListInProgress = false;
  TaskListByStatusModel? progressTaskListModel;
  final ProgressTaskController _progressTaskController = Get.find<ProgressTaskController>();

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: RefreshIndicator(
          onRefresh: _getProgressTaskList,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GetBuilder<ProgressTaskController>(
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
    );
  }

  Widget _buildTaskListView() {
    if (progressTaskListModel?.taskList?.isEmpty ?? true) {
      return const Center(
        child: Text(
          'No progress tasks available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: progressTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: progressTaskListModel!.taskList![index],
          onDelete: _getProgressTaskList,
          onStatusChanged: _getProgressTaskList,
        );
      },
    );
  }

  Future<void> _getProgressTaskList() async {
    final isSuccess = await _progressTaskController.getProgressTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _progressTaskController.errorMessage!);
    }
  }
}
