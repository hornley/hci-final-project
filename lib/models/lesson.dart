import '../models/quiz_problem.dart';

class Lesson {
  final String title;
  final String description;
  final String? imagePath;
  final List<LessonSection> sections;
  final List<QuizProblem> quizProblems;

  Lesson({
    required this.title,
    required this.description,
    this.imagePath,
    required this.sections,
    required this.quizProblems,
  });
}

enum ContentImageOrient { left, right }

enum LessonInteractionType {
  sliderExperiment,
  dragArrangement,
  toggleChoiceExperiment,
  chartExperiment,
}

class LessonInteraction {
  final LessonInteractionType type;
  final String title;
  final String prompt;
  final String? revealOnComplete;
  final bool requireForContinue;

  // Numeric experiment fields (slider/chart).
  final String? valueLabel;
  final String? valueUnit;
  final double minValue;
  final double maxValue;
  final double initialValue;
  final double? targetMin;
  final double? targetMax;
  final String? outputLabel;
  final double outputMultiplier;

  // Toggle/radio fields.
  final String? toggleLabel;
  final List<String>? options;
  final String? correctOption;

  // Drag arrangement fields.
  final List<String>? draggableOptions;
  final List<String>? expectedOrder;

  const LessonInteraction({
    required this.type,
    required this.title,
    required this.prompt,
    this.revealOnComplete,
    this.requireForContinue = true,
    this.valueLabel,
    this.valueUnit,
    this.minValue = 0,
    this.maxValue = 10,
    this.initialValue = 0,
    this.targetMin,
    this.targetMax,
    this.outputLabel,
    this.outputMultiplier = 1,
    this.toggleLabel,
    this.options,
    this.correctOption,
    this.draggableOptions,
    this.expectedOrder,
  });
}

class LessonSection {
  final String content;
  final String? message;
  final String? imagePath;
  final ContentImageOrient? contentImageOrient;
  final String? additionalContent;
  final List<LessonInteraction>? interactions;

  LessonSection({
    required this.content,
    this.message,
    this.imagePath,
    this.contentImageOrient,
    this.additionalContent,
    this.interactions,
  });
}
