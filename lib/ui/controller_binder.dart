import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager/ui/controllers/complete_task_controller.dart';
import 'package:task_manager/ui/controllers/forget_password_verify_email_controller.dart';
import 'package:task_manager/ui/controllers/forget_password_verify_otp_controller.dart';
import 'package:task_manager/ui/controllers/new_task_by_status_controller.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import 'package:task_manager/ui/controllers/resetPassword_controller.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';
import 'package:task_manager/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
    Get.lazyPut(()=> SignUpController());
    Get.lazyPut(() => VerifyMailController());
    Get.lazyPut(()=> VerifyOTPController());
    Get.lazyPut(()=> ResetPasswordController());
    Get.lazyPut(()=> UpdateProfileController());
    Get.put (NewTaskController());
    Get.put (ProgressTaskController());
    Get.put (CompleteTaskController());
    Get.put (CancelledTaskController());
  }
}