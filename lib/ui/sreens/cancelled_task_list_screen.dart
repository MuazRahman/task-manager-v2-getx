import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';


import '../widgets/screen_background.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/tm_app_bar.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  bool _getCancelledTaskListInProgress = false;
  TaskListByStatusModel? cancelledTaskListModel;
  final CancelledTaskController _cancelledTaskController = Get.find<CancelledTaskController>();

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: RefreshIndicator(
          onRefresh: _getCancelledTaskList,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GetBuilder<CancelledTaskController>(
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
    if (cancelledTaskListModel?.taskList?.isEmpty ?? true) {
      return const Center(
        child: Text(
          'No cancelled tasks available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: cancelledTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: cancelledTaskListModel!.taskList![index],
          onDelete: _getCancelledTaskList,
          onStatusChanged: _getCancelledTaskList,
        );
      },
    );
  }


  Future <void> _getCancelledTaskList() async {
    final isSuccess = await _cancelledTaskController.getCancelledTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _cancelledTaskController.errorMessage!);
    }
  }
}
