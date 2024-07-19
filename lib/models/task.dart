// lib/models/task.dart

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String expirationDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.expirationDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      expirationDate: json['expirationDate'],
    );
  }
}
