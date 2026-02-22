import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_task_management/model/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<List<Task>> getTasks(String userId) async {
    try {
      if (userId.isEmpty) {
        return [];
      }
      
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to fetch tasks: $e');
    }
  }
  
  Future<Task> addTask(Task task) async {
    try {
      final docRef = await _firestore.collection('tasks').add(task.toMap());
      
      // Return the task with the generated ID
      return Task(
        id: docRef.id,
        title: task.title,
        description: task.description,
        category: task.category,
        dueDate: task.dueDate,
        completed: task.completed,
        userId: task.userId,
        createdAt: task.createdAt,
        priority: task.priority,
        tags: task.tags,
      );
    } catch (e) {
      print('Error adding task: $e');
      throw Exception('Failed to add task: $e');
    }
  }
  
  Future<Task> updateTask(Task task) async {
    try {
      if (task.id == null || task.id!.isEmpty) {
        throw Exception('Task ID is required for update');
      }
      
      await _firestore
          .collection('tasks')
          .doc(task.id!)
          .update(task.toMap());
      
      return task;
    } catch (e) {
      print('Error updating task: $e');
      throw Exception('Failed to update task: $e');
    }
  }
  
  Future<void> deleteTask(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw Exception('Task ID is required for deletion');
      }
      
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print('Error deleting task: $e');
      throw Exception('Failed to delete task: $e');
    }
  }
}