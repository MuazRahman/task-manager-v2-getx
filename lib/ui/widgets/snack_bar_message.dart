import 'package:get/get.dart';

void showSnackBarMessage(String message) {
  Get.snackbar(
    'Notification',
    message,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
  );
}
