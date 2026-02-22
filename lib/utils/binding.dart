import 'package:get/get.dart';
import 'package:student_task_management/contoller/auth_controller.dart';
import 'package:student_task_management/contoller/task_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
  }
}