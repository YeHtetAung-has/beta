class Task {
  final int? id;
  final String title;
  final String? description;
  final String createdAt;
  final bool isCompleted;
  final String? completedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: map['createdAt'],
      isCompleted: map['isCompleted'] == 1,
      completedAt: map['completedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'isCompleted': isCompleted ? 1 : 0,
      'completedAt': completedAt,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? createdAt,
    bool? isCompleted,
    String? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
