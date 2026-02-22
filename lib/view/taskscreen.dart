import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:student_task_management/contoller/task_controller.dart';
import 'package:student_task_management/model/task_model.dart';

class TaskFormView extends StatefulWidget {
  final bool isEditing;
  final Task? task;

  TaskFormView({this.isEditing = false, this.task});

  @override
  _TaskFormViewState createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final TaskController taskController = Get.find();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  int selectedPriority = 2;
  List<String> categories = ['General', 'Study', 'Assignment', 'Project', 'Personal', 'Work'];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      categoryController.text = widget.task!.category;
      tagsController.text = widget.task!.tags ?? '';
      selectedDate = widget.task!.dueDate;
      selectedPriority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Task' : 'Add New Task'),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteTask,
              color: Colors.red,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.title),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter task title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Description Field
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.description),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: categoryController.text.isNotEmpty ? categoryController.text : 'General',
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.category),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    categoryController.text = value!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Due Date
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Due Date *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.calendar_today),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(selectedDate),
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Priority
              Text('Priority', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              SizedBox(height: 10),
              Row(
                children: [
                  _buildPriorityButton(1, 'Low', Colors.green),
                  SizedBox(width: 10),
                  _buildPriorityButton(2, 'Medium', Colors.orange),
                  SizedBox(width: 10),
                  _buildPriorityButton(3, 'High', Colors.red),
                ],
              ),
              SizedBox(height: 20),

              // Tags
              TextFormField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.tag),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _saveTask,
                  child: Text(
                    widget.isEditing ? 'Update Task' : 'Save Task',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityButton(int priority, String label, Color color) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: selectedPriority == priority ? color : Colors.grey[300]!,
            width: selectedPriority == priority ? 2 : 1,
          ),
          backgroundColor: selectedPriority == priority ? color.withOpacity(0.1) : Colors.white,
        ),
        onPressed: () {
          setState(() {
            selectedPriority = priority;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            color: selectedPriority == priority ? color : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveTask() {
  if (_formKey.currentState!.validate()) {
    final task = Task(
      id: widget.isEditing ? widget.task!.id : null,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: categoryController.text,
      dueDate: selectedDate,
      completed: widget.isEditing ? widget.task!.completed : false,
      userId: taskController.userId,
      createdAt: widget.isEditing ? widget.task!.createdAt : DateTime.now(),
      priority: selectedPriority,
      tags: tagsController.text.trim().isNotEmpty ? tagsController.text.trim() : null,
    );

    if (widget.isEditing) {
      taskController.updateTask(task);
    } else {
      taskController.addTask(task);
    }
  }
}

  void _deleteTask() {
    Get.defaultDialog(
      title: 'Delete Task',
      content: Text('Are you sure you want to delete this task? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Get.back();
            taskController.deleteTask(widget.task!.id!);
            Get.back();
          },
          child: Text('Delete'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    tagsController.dispose();
    super.dispose();
  }
}