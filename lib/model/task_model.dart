class Task {
  String? id;
  String title;
  String description;
  String category;
  DateTime dueDate;
  bool completed;
  String userId;
  DateTime createdAt;
  int priority;
  String? tags;

  Task({
    this.id,
    required this.title,
    this.description = '',
    this.category = 'General',
    required this.dueDate,
    this.completed = false,
    required this.userId,
    required this.createdAt,
    this.priority = 2,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'dueDate': dueDate.toIso8601String(),
      'completed': completed,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority,
      'tags': tags,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      dueDate: map['dueDate'] != null 
          ? DateTime.parse(map['dueDate']) 
          : DateTime.now(),
      completed: map['completed'] ?? false,
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      priority: map['priority'] ?? 2,
      tags: map['tags'],
    );
  }

  bool isOverdue(DateTime now) => !completed && dueDate.isBefore(now);
  
  bool get isDueToday {
    final now = DateTime.now();
    return !completed && 
           dueDate.year == now.year && 
           dueDate.month == now.month && 
           dueDate.day == now.day;
  }
  
  bool get isDueTomorrow {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return !completed && 
           dueDate.year == tomorrow.year && 
           dueDate.month == tomorrow.month && 
           dueDate.day == tomorrow.day;
  }
}