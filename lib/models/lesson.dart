import '../models/quiz_problem.dart';

class Lesson {
  final String title;
  final String description;
  final String? imagePath; // optional for lesson thumbnail
  final List<QuizProblem> quizProblems;

  Lesson({
    required this.title,
    required this.description,
    this.imagePath,
    required this.quizProblems,
  });
}
