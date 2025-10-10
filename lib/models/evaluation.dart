// lib/models/evaluation.dart

class Evaluation {
  final String title;
  final DateTime dueDate;
  bool isDone;

  Evaluation({required this.title, required this.dueDate, this.isDone = false});
}
