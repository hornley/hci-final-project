import 'package:flutter/material.dart';
import '../models/lesson.dart';
import 'quiz_screen.dart'; // Your quiz screen

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lesson.imagePath != null)
              Image.asset(
                lesson.imagePath!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(lesson.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            if (lesson.quizProblems.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizScreen(problems: lesson.quizProblems),
                    ),
                  );
                },
                child: const Text("Take Quiz"),
              ),
          ],
        ),
      ),
    );
  }
}

class LessonsScreen extends StatelessWidget {
  final List<Lesson> lessons;

  const LessonsScreen({super.key, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lessons")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: lesson.imagePath != null
                  ? Image.asset(
                      lesson.imagePath!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : null,
              title: Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(lesson.description),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailScreen(lesson: lesson),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
