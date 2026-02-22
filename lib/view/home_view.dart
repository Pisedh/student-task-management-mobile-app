import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_task_management/contoller/auth_controller.dart';
import 'package:student_task_management/contoller/task_controller.dart';
import 'package:student_task_management/model/task_model.dart';

import 'package:intl/intl.dart';
import 'package:student_task_management/view/taskscreen.dart';

class HomeView extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();
  final AuthController authController = Get.find<AuthController>();
  
  @override
  Widget build(BuildContext context) {
    final displayName = authController.currentUser.value?.displayName ?? 
                       authController.currentUser.value?.email?.split('@').first ?? 
                       'Student';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Task Manager'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context, displayName),
      body: Column(
        children: [
          // Welcome Section
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[800],
                  radius: 25,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Activity Overview Boxes
          Padding(
            padding: EdgeInsets.all(15),
            child: Obx(() => Row(
              children: [
                _buildActivityBox(
                  context,
                  'Pending',
                  taskController.pendingCount,
                  Colors.orange,
                  Icons.pending_actions,
                ),
                SizedBox(width: 10),
                _buildActivityBox(
                  context,
                  'Completed',
                  taskController.completedCount,
                  Colors.green,
                  Icons.check_circle,
                ),
                SizedBox(width: 10),
                _buildActivityBox(
                  context,
                  'Overdue',
                  taskController.overdueCount,
                  Colors.red,
                  Icons.warning,
                ),
              ],
            )),
          ),
          
          // Task List Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Icon(Icons.list, color: Colors.blue[800], size: 20),
                SizedBox(width: 8),
                Text(
                  'Your Tasks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Spacer(),
                Obx(() => Text(
                  '${taskController.tasks.length} total',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                )),
              ],
            ),
          ),
          
          // Task List
          Expanded(
            child: Obx(() {
              if (taskController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (taskController.tasks.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 80, color: Colors.grey[300]),
                        SizedBox(height: 20),
                        Text(
                          'No tasks yet',
                          style: TextStyle(
                            fontSize: 18, 
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tap the + button to add your first task',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () => taskController.fetchTasks(),
                child: ListView.builder(
                  itemCount: taskController.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskController.tasks[index];
                    return _buildTaskCard(task, context);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.to(() => TaskFormView()),
      ),
    );
  }
  
  Widget _buildDrawer(BuildContext context, String displayName) {
    final userEmail = authController.currentUser.value?.email ?? '';
    
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              displayName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
            decoration: BoxDecoration(
              color: Colors.blue[800],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: Colors.blue[700]),
                  title: Text('Home'),
                  onTap: () {
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blue[700]),
                  title: Text('Profile'),
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Profile',
                      'Profile feature will be available soon!',
                      backgroundColor: Colors.blue[50],
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.blue[700]),
                  title: Text('Settings'),
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Settings',
                      'Settings feature will be available soon!',
                      backgroundColor: Colors.blue[50],
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.help, color: Colors.blue[700]),
                  title: Text('Help & Support'),
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Help',
                      'Contact support@studenttaskmanager.com',
                      backgroundColor: Colors.blue[50],
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.blue[700]),
                  title: Text('About'),
                  onTap: () {
                    Get.back();
                    Get.defaultDialog(
                      title: 'About Student Task Manager',
                      content: Text('Version 1.0.0\n\nA simple task management app for students.'),
                      textConfirm: 'OK',
                      onConfirm: () => Get.back(),
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Get.back();
              Get.defaultDialog(
                title: 'Logout',
                content: Text('Are you sure you want to logout?'),
                textConfirm: 'Logout',
                confirmTextColor: Colors.white,
                textCancel: 'Cancel',
                onConfirm: () {
                  Get.back();
                  authController.logout();
                },
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityBox(BuildContext context, String title, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 10),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTaskCard(Task task, BuildContext context) {
    Color priorityColor = Colors.grey;
    String priorityText = 'Low';
    
    switch (task.priority) {
      case 1:
        priorityColor = Colors.green;
        priorityText = 'Low';
        break;
      case 2:
        priorityColor = Colors.orange;
        priorityText = 'Medium';
        break;
      case 3:
        priorityColor = Colors.red;
        priorityText = 'High';
        break;
    }
    
    final now = DateTime.now();
    final isOverdue = task.isOverdue(now);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: GestureDetector(
          onTap: () => taskController.toggleTask(task),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: task.completed ? Colors.green[100] : Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.completed ? Colors.green : Colors.blue,
              size: 24,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                  color: task.completed ? Colors.grey : Colors.black87,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: priorityColor.withOpacity(0.3), width: 1),
              ),
              child: Text(
                priorityText,
                style: TextStyle(
                  fontSize: 10,
                  color: priorityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                task.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(task.dueDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                  ),
                ),
                SizedBox(width: 12),
                if (task.isDueToday && !task.completed)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isOverdue && !task.completed)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Overdue',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (task.isDueTomorrow && !task.completed)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Tomorrow',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'edit') {
              Get.to(() => TaskFormView(isEditing: true, task: task));
            } else if (value == 'delete') {
              await _showDeleteDialog(task);
            }
          },
        ),
      ),
    );
  }
  
  Future<void> _showDeleteDialog(Task task) async {
    bool? result = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Get.back(result: true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      taskController.deleteTask(task.id!);
    }
  }
}