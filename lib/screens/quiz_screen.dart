import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/quiz_problem.dart';
import '../widgets/drag_drop.dart';
import '../widgets/multiple_choice.dart';
import '../widgets/true_or_false.dart';
import '../widgets/typing.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizProblem> problems;

  const QuizScreen({super.key, required this.problems});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  final Map<int, String> answers = {};

  void _previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (currentIndex < widget.problems.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          problems: widget.problems,
          answers: answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problems[currentIndex];
    final userAnswer = answers[currentIndex];

    Widget questionWidget;

    switch (problem.type) {
      case QuestionType.multipleChoice:
        questionWidget = MultipleChoiceQuestion(
          problem: problem,
          onAnswerSelected: (answer) =>
              setState(() => answers[currentIndex] = answer),
          selectedAnswer: userAnswer,
        );
        break;
      case QuestionType.trueFalse:
        questionWidget = TrueFalseQuestion(
          problem: problem,
          onAnswerSelected: (answer) =>
              setState(() => answers[currentIndex] = answer),
          selectedAnswer: userAnswer,
        );
        break;
      case QuestionType.typing:
        questionWidget = TypingQuestion(
          problem: problem,
          onAnswerSubmitted: (answer) =>
              setState(() => answers[currentIndex] = answer),
          initialText: userAnswer,
        );
        break;
      case QuestionType.dragAndDrop:
        questionWidget = DragDropQuestion(
          problem: problem,
          onAnswerDropped: (answer) =>
              setState(() => answers[currentIndex] = answer),
          initialAnswer: userAnswer,
        );
        break;
    }

    final isLastQuestion = currentIndex == widget.problems.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz (${currentIndex + 1}/${widget.problems.length})"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentIndex + 1) / widget.problems.length,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF395886),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  key: ValueKey<int>(currentIndex),
                  children: [
                    Expanded(child: questionWidget),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: currentIndex > 0 ? _previousQuestion : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Previous"),
                ),
                ElevatedButton.icon(
                  onPressed: _nextQuestion,
                  icon: Icon(isLastQuestion ? Icons.done : Icons.arrow_forward),
                  label: Text(isLastQuestion ? "Finish" : "Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Enhanced Results Screen with Confetti
class QuizResultsScreen extends StatefulWidget {
  final List<QuizProblem> problems;
  final Map<int, String> answers;

  const QuizResultsScreen({
    super.key,
    required this.problems,
    required this.answers,
  });

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    // Trigger confetti for good scores
    final score =
        _calculateScore(widget.problems, widget.answers);
    if (score >= 70) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  int _calculateScore(List<QuizProblem> problems, Map<int, String> answers) {
    int correct = 0;
    for (int i = 0; i < problems.length; i++) {
      if (answers[i] == problems[i].answer) {
        correct++;
      }
    }
    return ((correct / problems.length) * 100).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore(widget.problems, widget.answers);
    final percentage = (score / 100 * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Results"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Score card with animation
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text(
                            "Quiz Complete!",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: const Color(0xFF395886),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 20),
                          ScoreCircle(
                            score: score,
                            percentage: percentage,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            score >= 80
                                ? "Excellent work!"
                                : score >= 60
                                    ? "Good effort!"
                                    : "Keep practicing!",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Detailed results
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.problems.length,
                    itemBuilder: (context, index) {
                      final problem = widget.problems[index];
                      final userAnswer =
                          widget.answers[index] ?? "No answer";
                      final correct =
                          userAnswer == problem.answer;

                      return AnimatedOpacity(
                        opacity: 1,
                        duration: Duration(
                          milliseconds: 400 + (index * 100),
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Q${index + 1}: ${problem.question}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF395886),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      correct
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: correct
                                          ? Colors.green
                                          : Colors.red,
                                      size: 24,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: correct
                                        ? Colors.green[50]
                                        : Colors.red[50],
                                    borderRadius:
                                        BorderRadius.circular(8),
                                    border: Border.all(
                                      color: correct
                                          ? Colors.green[300] ??
                                              Colors.green
                                          : Colors.red[300] ??
                                              Colors.red,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Your answer: $userAnswer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      if (!correct) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          "Correct answer: ${problem.answer}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text("Back to Home"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Confetti effect
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Score Circle Widget
class ScoreCircle extends StatefulWidget {
  final int score;
  final String percentage;

  const ScoreCircle({
    super.key,
    required this.score,
    required this.percentage,
  });

  @override
  State<ScoreCircle> createState() => _ScoreCircleState();
}

class _ScoreCircleState extends State<ScoreCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100],
                ),
              ),
              // Progress circle
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.score >= 80
                        ? Colors.green
                        : widget.score >= 60
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ),
              // Score text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(widget.score * _animation.value).toInt()}",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF395886),
                    ),
                  ),
                  Text(
                    "%",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
