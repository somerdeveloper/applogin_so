// lib/models/evaluation.dart

class Evaluation {
  final String id;
  final String title;
  final DateTime dueDate;
  final String subjectId;
  final String subjectName;
  bool isDone;

  Evaluation({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.subjectId,
    required this.subjectName,
    this.isDone = false,
  });
}
