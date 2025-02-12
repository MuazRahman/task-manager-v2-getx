class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registrationUrl = '$_baseUrl/registration';
  static const String loginUrl = '$_baseUrl/login';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String taskCountByStatusUrl = '$_baseUrl/taskStatusCount';
  static String taskListByStatusUrl(String status) => '$_baseUrl/listTaskByStatus/$status';
  static String deleteTaskUrl(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatusUrl(String status) => '$_baseUrl/updateTaskStatus/62b7582fac0007cc76c29b53/$status';
  static const String updateProfile = '$_baseUrl/profileUpdate';
  static String recoverVerifyEmailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverVerifyOTPlUrl(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static String resetPasswordUrl = '$_baseUrl/RecoverResetPass';
}