import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';
import 'math_text.dart';

class TypingQuestion extends StatefulWidget {
  final QuizProblem problem;
  final String? initialText;
  final void Function(String) onAnswerSubmitted;

  const TypingQuestion({
    super.key,
    required this.problem,
    this.initialText,
    required this.onAnswerSubmitted,
  });

  @override
  State<TypingQuestion> createState() => _TypingQuestionState();
}

class _TypingQuestionState extends State<TypingQuestion> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_controller.text.isNotEmpty) {
      widget.onAnswerSubmitted(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MathText(
          widget.problem.question,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 60,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              hintText: "Type your answer here",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              fillColor: Theme.of(context).colorScheme.surface,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            onSubmitted: (_) => _submitAnswer(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            "Submit",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
