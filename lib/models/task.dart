class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime expirationDate;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.status,
    required this.expirationDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '', // Lidar com valores opcionais
      status: json['status'],
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }
}
