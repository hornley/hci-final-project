import '../models/lesson.dart';

class Subject {
  final String title;
  final String description;
  final String? imagePath;
  final List<Lesson> lessons;

  Subject({
    required this.title,
    required this.description,
    this.imagePath,
    required this.lessons,
  });
}
