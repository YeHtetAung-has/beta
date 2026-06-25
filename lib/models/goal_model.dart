class Goal {
  final int? id;
  final String title;
  final String createdAt;

  Goal({this.id, required this.title, required this.createdAt});

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'createdAt': createdAt,
  };

  factory Goal.fromMap(Map<String, dynamic> map) =>
      Goal(id: map['id'], title: map['title'], createdAt: map['createdAt']);
}
