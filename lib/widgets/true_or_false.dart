import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';

class TrueFalseQuestion extends StatelessWidget {
  final QuizProblem problem;
  final String? selectedAnswer;
  final void Function(String) onAnswerSelected;

  const TrueFalseQuestion({
    super.key,
    required this.problem,
    this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          problem.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF395886),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ["True", "False"].map((option) {
            final isSelected = selectedAnswer == option;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isSelected
                    ? (option == "True"
                        ? Colors.green
                        : Colors.red)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? (option == "True"
                          ? Colors.green
                          : Colors.red)
                      : Colors.grey[300] ?? Colors.grey,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (option == "True"
                                  ? Colors.green
                                  : Colors.red)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onAnswerSelected(option),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 8),
                          Icon(
                            Icons.check_circle,
                            color: option == "True"
                                ? Colors.white
                                : Colors.white,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
