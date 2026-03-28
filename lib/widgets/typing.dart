import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';

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
  late FocusNode _focusNode;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.initialText != null) {
      _controller.text = widget.initialText!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_controller.text.isNotEmpty) {
      setState(() => _isSubmitted = true);
      widget.onAnswerSubmitted(_controller.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Answer submitted! ✓"),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.problem.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF395886),
          ),
        ),
        const SizedBox(height: 30),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? const Color(0xFF395886)
                  : Colors.grey[300] ?? Colors.grey,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: const Color(0xFF395886).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Type your answer here",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              suffixIcon: _isSubmitted
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    )
                  : null,
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            onSubmitted: (_) => _submitAnswer(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _submitAnswer,
          icon: const Icon(Icons.send),
          label: const Text(
            "Submit Answer",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: const Color(0xFF395886),
          ),
        ),
      ],
    );
  }
}
