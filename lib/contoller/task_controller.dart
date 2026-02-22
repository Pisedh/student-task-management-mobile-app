import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_task_management/contoller/auth_controller.dart';
import 'package:student_task_management/model/task_model.dart';
import 'package:student_task_management/services/task_service.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final RxList<Task> pendingTasks = <Task>[].obs;
  final RxList<Task> completedTasks = <Task>[].obs;
  final RxList<Task> overdueTasks = <Task>[].obs;
  final RxBool isLoading = false.obs;
  final TaskService _taskService = TaskService();
  
  String get userId {
    final uid = Get.find<AuthController>().currentUser.value?.uid;
    if (uid == null || uid.isEmpty) {
      print("Warning: userId is empty - cannot fetch tasks");
      return '';
    }
    return uid;
  }@override
  void onInit() {
    super.onInit();
   
    ever(Get.find<AuthController>().isLoggedIn, (bool loggedIn) {
      if (loggedIn && userId.isNotEmpty) {
        fetchTasks();
      }
    });

   
    if (Get.find<AuthController>().isLoggedIn.value && userId.isNotEmpty) {
      fetchTasks();
    }
  }

  Future<void> fetchTasks() async {
    if (userId.isEmpty) return;
    
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final taskList = await _taskService.getTasks(userId);
      tasks.assignAll(taskList);
      _categorizeTasks();
    } catch (e) {
      print('Error fetching tasks: $e');
      Get.snackbar('Error', 'Failed to load tasks', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
  
  void _categorizeTasks() {
    final now = DateTime.now();
    pendingTasks.value = tasks.where((task) => 
      !task.completed && 
      !task.isOverdue(now)
    ).toList();
    
    completedTasks.value = tasks.where((task) => 
      task.completed
    ).toList();
    
    overdueTasks.value = tasks.where((task) => 
      !task.completed && 
      task.isOverdue(now)
    ).toList();
  }
  
  Future<void> addTask(Task task) async {
    try {
      final newTask = await _taskService.addTask(task);
      tasks.insert(0, newTask);
      _categorizeTasks();
      Get.back();
      Get.snackbar(
        'Success', 
        'Task added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error adding task: $e');
      Get.snackbar(
        'Error', 
        'Failed to add task: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = await _taskService.updateTask(task);
      final index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
        _categorizeTasks();
      }
      Get.back();
      Get.snackbar(
        'Success', 
        'Task updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating task: $e');
      Get.snackbar(
        'Error', 
        'Failed to update task: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> toggleTask(Task task) async {
    try {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        category: task.category,
        dueDate: task.dueDate,
        completed: !task.completed,
        userId: task.userId,
        createdAt: task.createdAt,
        priority: task.priority,
        tags: task.tags,
      );
      await updateTask(updatedTask);
    } catch (e) {
      Get.snackbar(
        'Error', 
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      tasks.removeWhere((task) => task.id == taskId);
      _categorizeTasks();
      Get.snackbar(
        'Success', 
        'Task deleted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting task: $e');
      Get.snackbar(
        'Error', 
        'Failed to delete task: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  int get pendingCount => pendingTasks.length;
  int get completedCount => completedTasks.length;
  int get overdueCount => overdueTasks.length;
}