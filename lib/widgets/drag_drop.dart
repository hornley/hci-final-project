import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';

class DragDropQuestion extends StatefulWidget {
  final QuizProblem problem;
  final String? initialAnswer;
  final void Function(String) onAnswerDropped; // Callback to notify parent

  const DragDropQuestion({
    super.key,
    required this.problem,
    this.initialAnswer,
    required this.onAnswerDropped,
  });

  @override
  State<DragDropQuestion> createState() => _DragDropQuestionState();
}

class _DragDropQuestionState extends State<DragDropQuestion> {
  String? droppedAnswer;

  @override
  Widget build(BuildContext context) {
    final problem = widget.problem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(problem.question, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 40),
        // Draggable options
        if (problem.options != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: problem.options!.map((option) {
              return Draggable<String>(
                data: option,
                feedback: Material(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue,
                    child: Text(
                      option,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.grey,
                  child: Text(option),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue,
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 50),
        // Drag target
        DragTarget<String>(
          onAcceptWithDetails: (details) {
            final data = details.data;
            setState(() {
              droppedAnswer = data;
            });
            widget.onAnswerDropped(data);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 250,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: candidateData.isEmpty
                    ? Colors.grey[200]
                    : Colors.yellow[200],
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text(
                droppedAnswer ?? "Drop the answer here",
                style: const TextStyle(fontSize: 18),
              ),
            );
          },
        ),
      ],
    );
  }
}
