class TaskModel {
  final int id;
  final String title;
  final String description;
  final DateTime? dtClose;
  final bool? isComplete;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.dtClose,
    this.isComplete,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isComplete: map['is_complete'] == 1,
      dtClose: map['dt_close'] != null ? DateTime.parse(map['dt_close']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'is_complete': (isComplete ?? false) ? 1 : 0,
      'dt_close': dtClose?.toIso8601String(),
    };
  }

  /// Método `copyWith`
  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dtClose,
    bool? isComplete,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dtClose: dtClose ?? this.dtClose,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
