import 'package:hci_final_project/data/sample_problems.dart';
import '../models/lesson.dart';
import '../models/subject.dart';

final linearAlgebraLessons = [
  Lesson(
    title: "Vectors",
    description: "Learn about vectors, addition, and scalar multiplication.",
    quizProblems: sampleProblems, // list of QuizProblem for this lesson
  ),
  Lesson(
    title: "Matrices",
    description: "Introduction to matrices, operations, and determinants.",
    quizProblems: sampleProblems,
  ),
];

final subjects = [
  Subject(
    title: "Linear Algebra",
    description: "Dive into vectors, matrices, and transformations.",
    lessons: linearAlgebraLessons,
  ),
];
