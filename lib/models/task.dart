class Task {
  final int? id;
  final int userId;
  final String title;
  final String description;
  final bool completed;

  const Task({
    this.id,
    this.userId = 1,
    required this.title,
    this.description = '',
    this.completed = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final userId = json['userId'];

    return Task(
      id: id is int ? id : int.tryParse('$id'),
      userId: userId is int ? userId : int.tryParse('$userId') ?? 1,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      completed: json['completed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'title': title,
      'completed': completed,
      if (description.isNotEmpty) 'description': description,
    };
  }

  Task copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
