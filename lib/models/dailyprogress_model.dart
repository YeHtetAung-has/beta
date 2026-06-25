class DailyProgress {
  final int? id;
  final String date;
  final int completedTasks;

  DailyProgress({this.id, required this.date, required this.completedTasks});

  factory DailyProgress.fromMap(Map<String, dynamic> map) {
    return DailyProgress(
      id: map['id'],
      date: map['date'],
      completedTasks: map['completedTasks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'completedTasks': completedTasks};
  }

  DailyProgress copyWith({int? id, String? date, int? completedTasks}) {
    return DailyProgress(
      id: id ?? this.id,
      date: date ?? this.date,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}
