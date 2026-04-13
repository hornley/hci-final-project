import 'package:flutter/material.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import '../models/quiz_problem.dart';
import '../local_storage.dart';
import '../progress_manager.dart';
import '../quest_manager.dart';
import '../widgets/drag_drop.dart';
import '../widgets/math_text.dart';
import '../widgets/multiple_choice.dart';
import '../widgets/true_or_false.dart';
import '../widgets/typing.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizProblem> problems;
  final Color? themeColor;
  final String lessonTitle;
  final int backToLessonsPopCount;

  const QuizScreen({
    super.key,
    required this.problems,
    required this.lessonTitle,
    this.themeColor,
    this.backToLessonsPopCount = 2,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  final Map<int, String> answers = {}; // Store all user answers
  final Map<int, String> _typingDrafts = {};

  void _showHint() {
    final problem = widget.problems[currentIndex];
    final hint = problem.hint?.trim();
    final message = (hint != null && hint.isNotEmpty)
        ? hint
        : 'No hint available for this question yet.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hint: $message'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  bool _hasMeaningfulAnswer(String? value, QuestionType type) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return false;
    }
    if (type == QuestionType.dragAndDrop) {
      return normalized.split(',').any((part) => part.trim().isNotEmpty);
    }
    return true;
  }

  Future<bool> _confirmContinueWithoutAnswer() async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            'Continue without answering?',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'You have not provided an answer for this question yet.',
            style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.9)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              style: TextButton.styleFrom(
                foregroundColor: scheme.onSurface,
                side: BorderSide(
                  color: scheme.onSurface.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
    return proceed == true;
  }

  Future<void> _nextQuestion() async {
    final problem = widget.problems[currentIndex];

    if (problem.type == QuestionType.typing) {
      final draft = (_typingDrafts[currentIndex] ?? '').trim();
      if (draft.isNotEmpty) {
        setState(() {
          answers[currentIndex] = draft;
        });
      }
    }

    final hasAnswer = _hasMeaningfulAnswer(answers[currentIndex], problem.type);
    if (!hasAnswer) {
      final shouldContinue = await _confirmContinueWithoutAnswer();
      if (!shouldContinue || !mounted) {
        return;
      }
    }

    if (currentIndex < widget.problems.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Last question → Finish
      _showResults();
    }
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          problems: widget.problems,
          answers: answers,
          lessonTitle: widget.lessonTitle,
          themeColor: widget.themeColor,
          backToLessonsPopCount: widget.backToLessonsPopCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problems[currentIndex];
    final userAnswer = answers[currentIndex];
    final themeColor = widget.themeColor;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonBackground = isDark
        ? context.appColors.action
        : (themeColor ?? context.appColors.action);
    final buttonForeground = buttonBackground.computeLuminance() > 0.6
        ? Colors.black87
        : Colors.white;

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
          onDraftChanged: (value) {
            _typingDrafts[currentIndex] = value;
          },
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
        actions: const [ThemeToggleButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: questionWidget,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _previousQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackground,
                    foregroundColor: buttonForeground,
                    disabledBackgroundColor: scheme.surfaceContainerHighest,
                    disabledForegroundColor: scheme.onSurface.withValues(
                      alpha: 0.45,
                    ),
                  ),
                  child: Text(
                    "Previous",
                    style: TextStyle(
                      color: buttonForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _showHint,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text("Hint"),
                ),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackground,
                    foregroundColor: buttonForeground,
                  ),
                  child: Text(
                    isLastQuestion ? "Finish" : "Next",
                    style: TextStyle(
                      color: buttonForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple Results Screen
class QuizResultsScreen extends StatefulWidget {
  final List<QuizProblem> problems;
  final Map<int, String> answers;
  final String lessonTitle;
  final Color? themeColor;
  final int backToLessonsPopCount;

  const QuizResultsScreen({
    super.key,
    required this.problems,
    required this.answers,
    required this.lessonTitle,
    this.themeColor,
    this.backToLessonsPopCount = 2,
  });

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  static const int _baseQuizExpReward = 15;
  static const int _baseQuizCoinReward = 5;
  static const int _perCorrectExpReward = 2;
  static const int _perCorrectCoinReward = 1;

  QuestCompletionResult? _rewardResult;
  int _quizExpReward = 0;
  int _quizCoinReward = 0;
  bool _isRetakeWithoutRewards = false;
  final Set<int> _revealedAnswerIndexes = <int>{};

  String _normalizeAnswer(String input) {
    var value = input.trim().toLowerCase();
    value = value.replaceAll(r'$', '');
    value = value.replaceAllMapped(
      RegExp(r'\\(?:text|mathrm)\{([^}]*)\}'),
      (match) => match.group(1) ?? '',
    );
    value = value.replaceAll(RegExp(r'\\(?:left|right)'), '');

    final looksMath = RegExp(
      r'[0-9=+\-*/^_()\[\],]|\\(?:frac|sqrt|int|cdot|times|det|lambda|begin|end)',
    ).hasMatch(value);

    value = value.replaceAll('−', '-');
    value = value.replaceAll(r'\times', '*');
    value = value.replaceAll(r'\cdot', '*');
    value = value.replaceAll(r'\,', '');

    if (looksMath) {
      value = value.replaceAll(RegExp(r'[{}\\]'), '');
      value = value.replaceAll(RegExp(r'\s+'), '');
      return value;
    }

    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    return value;
  }

  bool _answersMatch(String userAnswer, String expectedAnswer) {
    return _normalizeAnswer(userAnswer) == _normalizeAnswer(expectedAnswer);
  }

  @override
  void initState() {
    super.initState();
    _completeRelatedQuests();
  }

  Future<void> _completeRelatedQuests() async {
    final totalQuestions = widget.problems.length;
    final correctQuestionIndexes = <int>{};

    final correctAnswers = widget.answers.entries.where((entry) {
      final index = entry.key;
      final answer = entry.value;
      if (index < 0 || index >= widget.problems.length) {
        return false;
      }
      final matches = _answersMatch(answer, widget.problems[index].answer);
      if (matches) {
        correctQuestionIndexes.add(index);
      }
      return matches;
    }).length;

    await ProgressManager.recordQuizCompletion(
      lessonTitle: widget.lessonTitle,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
    );

    final rewardProgress = await ProgressManager.getQuizRewardProgress(
      widget.lessonTitle,
    );
    final newlyRewardedIndexes = correctQuestionIndexes.difference(
      rewardProgress.rewardedQuestionIndexes,
    );
    final shouldClaimBaseReward = !rewardProgress.baseClaimed;

    final quizExpReward =
        (shouldClaimBaseReward ? _baseQuizExpReward : 0) +
        (newlyRewardedIndexes.length * _perCorrectExpReward);
    final quizCoinReward =
        (shouldClaimBaseReward ? _baseQuizCoinReward : 0) +
        (newlyRewardedIndexes.length * _perCorrectCoinReward);

    if (quizExpReward > 0) {
      await LocalStorage.addExp(quizExpReward);
    }
    if (quizCoinReward > 0) {
      await LocalStorage.addCoins(quizCoinReward);
    }

    final result = await QuestManager.completeQuestsForLesson(
      lessonTitle: widget.lessonTitle,
    );
    if (!mounted) return;

    await ProgressManager.markQuizRewardProgress(
      lessonTitle: widget.lessonTitle,
      claimBase: shouldClaimBaseReward,
      questionIndexes: newlyRewardedIndexes,
    );
    if (!mounted) return;

    setState(() {
      _rewardResult = result;
      _quizExpReward = quizExpReward;
      _quizCoinReward = quizCoinReward;
      _isRetakeWithoutRewards =
          !shouldClaimBaseReward &&
          newlyRewardedIndexes.isEmpty &&
          !result.hasRewards;
    });

    final questCount = result.completedQuests.length;
    final questLabel = questCount == 1 ? 'quest' : 'quests';
    final totalExp = quizExpReward + result.totalExpReward;
    final totalCoins = quizCoinReward + result.totalCoinReward;

    final quizRewardMessage =
        'Quiz reward: +$quizExpReward EXP, +$quizCoinReward coins. '
        'Newly rewarded questions: ${newlyRewardedIndexes.length}/$totalQuestions.';

    final message = result.hasRewards
        ? '$quizRewardMessage '
              'Completed $questCount $questLabel. '
              '+${result.totalExpReward} EXP, +${result.totalCoinReward} coins.'
        : quizRewardMessage;

    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(
          20,
          size.height * 0.38,
          20,
          size.height * 0.38,
        ),
        content: Text('$message Total: +$totalExp EXP, +$totalCoins coins.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonBackground = isDark
        ? context.appColors.action
        : (widget.themeColor ?? context.appColors.action);
    final buttonForeground = buttonBackground.computeLuminance() > 0.6
        ? Colors.black87
        : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
        actions: const [ThemeToggleButton()],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _isRetakeWithoutRewards
                  ? 'Retake detected: no rewards granted for this lesson quiz.'
                  : _rewardResult?.hasRewards == true
                  ? 'Rewards collected: '
                        'Quiz +$_quizExpReward EXP, +$_quizCoinReward coins • '
                        'Quest +${_rewardResult!.totalExpReward} EXP, +${_rewardResult!.totalCoinReward} coins'
                  : 'Quiz rewards collected: +$_quizExpReward EXP, +$_quizCoinReward coins',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),

          // 🔹 LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.problems.length,
              itemBuilder: (context, index) {
                final problem = widget.problems[index];
                final userAnswer = widget.answers[index] ?? "No answer";
                final correct = _answersMatch(userAnswer, problem.answer);
                final showAnswer = _revealedAnswerIndexes.contains(index);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MathText(
                          "Q${index + 1}: ${problem.question}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        MathText(
                          "Your answer: $userAnswer",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (showAnswer) {
                                _revealedAnswerIndexes.remove(index);
                              } else {
                                _revealedAnswerIndexes.add(index);
                              }
                            });
                          },
                          child: Text(
                            showAnswer ? 'Hide answer' : 'Show answer',
                          ),
                        ),
                        if (showAnswer)
                          MathText(
                            "Correct answer: ${problem.answer}",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                          ),
                        Text(
                          "Result: ${correct ? '✅ Correct' : '❌ Incorrect'}",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 BUTTON (ALWAYS AT BOTTOM)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  for (var i = 0; i < widget.backToLessonsPopCount; i++) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBackground,
                  foregroundColor: buttonForeground,
                ),
                child: Text(
                  "Back to Lessons",
                  style: TextStyle(
                    color: buttonForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
