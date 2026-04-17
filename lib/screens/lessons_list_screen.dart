import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/achievement_manager.dart';
import 'package:hci_final_project/progress_manager.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import '../models/lesson.dart';
import 'quiz_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final Color? themeColor;
  final VoidCallback? onProgressUpdated;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    this.themeColor,
    this.onProgressUpdated,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: const [ThemeToggleButton()],
      ),
      body: LessonDetailBody(
        lesson: lesson,
        themeColor: widget.themeColor,
        onProgressUpdated: widget.onProgressUpdated,
      ),
    );
  }
}

class LessonDetailBody extends StatefulWidget {
  final Lesson lesson;
  final Color? themeColor;
  final bool showBackButton;
  final VoidCallback? onProgressUpdated;

  const LessonDetailBody({
    super.key,
    required this.lesson,
    this.themeColor,
    this.showBackButton = true,
    this.onProgressUpdated,
  });

  @override
  State<LessonDetailBody> createState() => _LessonDetailBodyState();
}

class _LessonDetailBodyState extends State<LessonDetailBody> {
  int _visibleSectionCount = 1;
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _sectionKeys;
  final Map<int, bool> _sectionInteractionReady = {};
  bool _canSkipToEnd = false;

  @override
  void initState() {
    super.initState();
    _sectionKeys = List.generate(
      widget.lesson.sections.length,
      (_) => GlobalKey(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markLessonReadIfComplete();
    });
    _refreshSkipAvailability();
  }

  @override
  void didUpdateWidget(covariant LessonDetailBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.title != widget.lesson.title) {
      _visibleSectionCount = 1;
      _sectionInteractionReady.clear();
      _sectionKeys = List.generate(
        widget.lesson.sections.length,
        (_) => GlobalKey(),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _markLessonReadIfComplete();
      });
      _refreshSkipAvailability();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _hasMoreSections =>
      _visibleSectionCount < widget.lesson.sections.length;

  bool _sectionRequiresInteraction(int index) {
    final interactions = widget.lesson.sections[index].interactions;
    return interactions != null && interactions.isNotEmpty;
  }

  bool _isSectionReady(int index) {
    if (!_sectionRequiresInteraction(index)) {
      return true;
    }
    return _sectionInteractionReady[index] ?? false;
  }

  bool get _canContinueFromCurrentSection {
    final currentIndex = _visibleSectionCount - 1;
    if (currentIndex < 0 || currentIndex >= widget.lesson.sections.length) {
      return true;
    }
    return _isSectionReady(currentIndex);
  }

  Future<void> _markLessonReadIfComplete() async {
    if (_visibleSectionCount >= widget.lesson.sections.length) {
      await ProgressManager.markLessonRead(widget.lesson.title);
      await AchievementManager().evaluateAndUnlock();
      if (mounted) {
        await AchievementManager().showPendingCompletionPopups(context);
      }
      widget.onProgressUpdated?.call();
      if (!mounted) {
        return;
      }
      setState(() {
        _canSkipToEnd = true;
      });
    }
  }

  Future<void> _refreshSkipAvailability() async {
    final statuses = await ProgressManager.getLessonProgressStatuses([
      widget.lesson.title,
    ]);
    final status = statuses[widget.lesson.title];
    if (!mounted) {
      return;
    }
    setState(() {
      _canSkipToEnd =
          status?.lessonRead == true || status?.quizCompleted == true;
    });
  }

  void _skipToEnd() {
    setState(() {
      _visibleSectionCount = widget.lesson.sections.length;
    });
    _markLessonReadIfComplete();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  void _continueSection() {
    if (_hasMoreSections) {
      final nextIndex = _visibleSectionCount;
      setState(() {
        _visibleSectionCount++;
      });
      _markLessonReadIfComplete();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final targetContext = _sectionKeys[nextIndex].currentContext;
        if (targetContext != null) {
          Scrollable.ensureVisible(
            targetContext,
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeOutCubic,
            alignment: 0.08,
          );
          return;
        }

        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.themeColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final buttonBackground = isDark ? primary : (themeColor ?? primary);
    final buttonForeground = isDark
        ? Colors.white
        : (buttonBackground.computeLuminance() > 0.7
              ? Colors.black87
              : Colors.white);
    final outlineForeground = isDark
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;
    final outlineSideColor = isDark
        ? Colors.white
        : (themeColor ?? outlineForeground);
    final width = MediaQuery.of(context).size.width;
    final contentMaxWidth = width >= 1400
        ? 760.0
        : width >= 1100
        ? 680.0
        : 900.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (
                        var index = 0;
                        index < _visibleSectionCount;
                        index++
                      ) ...[
                        _LessonSectionCard(
                          key: _sectionKeys[index],
                          section: widget.lesson.sections[index],
                          onInteractionReadyChanged: (isReady) {
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _sectionInteractionReady[index] = isReady;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                      ],
                      if (_hasMoreSections)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_canSkipToEnd)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: _skipToEnd,
                                  icon: const Icon(Icons.skip_next_rounded),
                                  label: const Text('Skip to End'),
                                ),
                              ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _canContinueFromCurrentSection
                                    ? _continueSection
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonBackground,
                                  foregroundColor: buttonForeground,
                                ),
                                child: Text(
                                  'Continue ($_visibleSectionCount/${widget.lesson.sections.length})',
                                ),
                              ),
                            ),
                            if (!_canContinueFromCurrentSection) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Complete the interactive activity above to unlock the next section.',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ],
                        )
                      else
                        Column(
                          children: [
                            if (widget.lesson.quizProblems.isNotEmpty)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final hasPerfectScore =
                                        await ProgressManager.hasPerfectQuizScore(
                                          widget.lesson.title,
                                        );
                                    if (!mounted) {
                                      return;
                                    }

                                    if (hasPerfectScore) {
                                      final shouldRetake = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          final scheme = Theme.of(
                                            context,
                                          ).colorScheme;
                                          final isDark =
                                              Theme.of(context).brightness ==
                                              Brightness.dark;
                                          final dialogTextColor = isDark
                                              ? Colors.white
                                              : scheme.onSurface;

                                          return AlertDialog(
                                            title: Text(
                                              'Retake quiz?',
                                              style: TextStyle(
                                                color: dialogTextColor,
                                              ),
                                            ),
                                            content: Text(
                                              'You already completed this quiz with 100%. Do you still want to retake it?',
                                              style: TextStyle(
                                                color: dialogTextColor,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                                child: const Text('Retake'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (shouldRetake != true || !mounted) {
                                        return;
                                      }
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizScreen(
                                          problems: widget.lesson.quizProblems,
                                          themeColor: themeColor,
                                          lessonTitle: widget.lesson.title,
                                          backToLessonsPopCount:
                                              widget.showBackButton ? 2 : 1,
                                        ),
                                      ),
                                    ).then(
                                      (_) => widget.onProgressUpdated?.call(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonBackground,
                                    foregroundColor: buttonForeground,
                                  ),
                                  child: const Text('Take Quiz'),
                                ),
                              ),
                            if (widget.showBackButton) ...[
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: outlineForeground,
                                    side: BorderSide(color: outlineSideColor),
                                  ),
                                  child: const Text('Back to Lessons'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      const SizedBox(height: 8),
                    ],
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

class _LessonSectionCard extends StatefulWidget {
  final LessonSection section;
  final ValueChanged<bool>? onInteractionReadyChanged;

  const _LessonSectionCard({
    super.key,
    required this.section,
    this.onInteractionReadyChanged,
  });

  @override
  State<_LessonSectionCard> createState() => _LessonSectionCardState();
}

class _LessonSectionCardState extends State<_LessonSectionCard> {
  late List<bool> _interactionCompletion;

  @override
  void initState() {
    super.initState();
    _resetInteractionCompletion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyInteractionReady();
    });
  }

  @override
  void didUpdateWidget(covariant _LessonSectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section != widget.section) {
      _resetInteractionCompletion();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifyInteractionReady();
      });
    }
  }

  void _resetInteractionCompletion() {
    final count = widget.section.interactions?.length ?? 0;
    _interactionCompletion = List<bool>.filled(count, false);
  }

  void _notifyInteractionReady() {
    final interactions = widget.section.interactions;
    if (interactions == null || interactions.isEmpty) {
      widget.onInteractionReadyChanged?.call(true);
      return;
    }

    var isReady = true;
    for (var i = 0; i < interactions.length; i++) {
      if (interactions[i].requireForContinue && !_interactionCompletion[i]) {
        isReady = false;
        break;
      }
    }
    widget.onInteractionReadyChanged?.call(isReady);
  }

  void _setInteractionCompletion(int index, bool isComplete) {
    if (_interactionCompletion[index] == isComplete) {
      return;
    }

    setState(() {
      _interactionCompletion[index] = isComplete;
    });
    _notifyInteractionReady();
  }

  Widget _buildContentText(BuildContext context, String text) {
    final textStyle = GoogleFonts.inter(
      fontSize: 14,
      color: Theme.of(context).colorScheme.onSurface,
    );

    final blockRegex = RegExp(r'\$\$([\s\S]*?)\$\$');
    final widgets = <Widget>[];
    var cursor = 0;

    for (final match in blockRegex.allMatches(text)) {
      final before = text.substring(cursor, match.start);
      if (before.trim().isNotEmpty) {
        widgets.add(_buildInlineMathText(before, textStyle));
      }

      final blockFormula = (match.group(1) ?? '').trim();
      if (blockFormula.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Math.tex(
                blockFormula,
                mathStyle: MathStyle.display,
                textStyle: textStyle,
                onErrorFallback: (error) =>
                    Text(blockFormula, style: textStyle),
              ),
            ),
          ),
        );
      }
      cursor = match.end;
    }

    final tail = text.substring(cursor);
    if (tail.trim().isNotEmpty || widgets.isEmpty) {
      widgets.add(_buildInlineMathText(tail, textStyle));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildInlineMathText(String text, TextStyle textStyle) {
    final inlineRegex = RegExp(r'\$([^\$]+)\$');
    final spans = <InlineSpan>[];
    var cursor = 0;

    for (final match in inlineRegex.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }

      final expression = (match.group(1) ?? '').trim();
      if (expression.isNotEmpty) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              expression,
              textStyle: textStyle,
              onErrorFallback: (error) => Text(expression, style: textStyle),
            ),
          ),
        );
      }
      cursor = match.end;
    }

    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return RichText(
      text: TextSpan(style: textStyle, children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 900;
    final imageMaxWidth = width >= 1400
        ? 420.0
        : width >= 1100
        ? 480.0
        : 560.0;

    final imageWidget = widget.section.imagePath == null
        ? null
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: imageMaxWidth),
            child: Image.asset(
              widget.section.imagePath!,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          );

    final contentWidget = _buildContentText(context, widget.section.content);

    final useSideBySide =
        !isCompact &&
        imageWidget != null &&
        widget.section.contentImageOrient != null;

    Widget buildMainContentBlock() {
      if (useSideBySide) {
        final isContentLeft =
            widget.section.contentImageOrient == ContentImageOrient.left;
        final left = isContentLeft
            ? Expanded(child: contentWidget)
            : Expanded(child: imageWidget);
        final right = isContentLeft
            ? Expanded(child: imageWidget)
            : Expanded(child: contentWidget);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [left, const SizedBox(width: 16), right],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageWidget != null) ...[
            Center(child: imageWidget),
            const SizedBox(height: 12),
          ],
          contentWidget,
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.section.message != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.section.message!,
                style: GoogleFonts.inter(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          buildMainContentBlock(),
          if (widget.section.additionalContent != null) ...[
            const SizedBox(height: 12),
            _buildContentText(context, widget.section.additionalContent!),
          ],
          if (widget.section.interactions != null &&
              widget.section.interactions!.isNotEmpty) ...[
            const SizedBox(height: 14),
            for (var i = 0; i < widget.section.interactions!.length; i++) ...[
              _LessonInteractionCard(
                interaction: widget.section.interactions![i],
                onCompletionChanged: (isComplete) {
                  _setInteractionCompletion(i, isComplete);
                },
              ),
              if (i < widget.section.interactions!.length - 1)
                const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}

class _LessonInteractionCard extends StatefulWidget {
  final LessonInteraction interaction;
  final ValueChanged<bool> onCompletionChanged;

  const _LessonInteractionCard({
    required this.interaction,
    required this.onCompletionChanged,
  });

  @override
  State<_LessonInteractionCard> createState() => _LessonInteractionCardState();
}

class _LessonInteractionCardState extends State<_LessonInteractionCard> {
  late double _value;
  late double _chartInput;
  bool _toggleOn = false;
  String? _selectedOption;
  late List<String?> _dragPlaced;
  bool _isDragSkipped = false;

  Color _primaryText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: isDark ? 0.98 : 0.9);
  }

  Color _secondaryText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: isDark ? 0.9 : 0.78);
  }

  @override
  void initState() {
    super.initState();
    final interaction = widget.interaction;
    _value = interaction.initialValue;
    _chartInput = interaction.initialValue;
    _dragPlaced = List<String?>.filled(
      interaction.expectedOrder?.length ?? 0,
      null,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyCompletion();
    });
  }

  bool get _isComplete {
    final interaction = widget.interaction;

    switch (interaction.type) {
      case LessonInteractionType.sliderExperiment:
      case LessonInteractionType.chartExperiment:
        final min = interaction.targetMin;
        final max = interaction.targetMax;
        if (min != null && max != null) {
          final current =
              interaction.type == LessonInteractionType.chartExperiment
              ? _chartInput
              : _value;
          return current >= min && current <= max;
        }
        final baseline = interaction.initialValue;
        final current =
            interaction.type == LessonInteractionType.chartExperiment
            ? _chartInput
            : _value;
        return (current - baseline).abs() >= 0.5;
      case LessonInteractionType.dragArrangement:
        if (_isDragSkipped) {
          return true;
        }
        final expected = interaction.expectedOrder;
        if (expected == null || expected.isEmpty) {
          return true;
        }
        if (_dragPlaced.any((item) => item == null)) {
          return false;
        }
        for (var i = 0; i < expected.length; i++) {
          if (_dragPlaced[i] != expected[i]) {
            return false;
          }
        }
        return true;
      case LessonInteractionType.toggleChoiceExperiment:
        return _toggleOn &&
            widget.interaction.correctOption != null &&
            _selectedOption == widget.interaction.correctOption;
    }
  }

  void _notifyCompletion() {
    widget.onCompletionChanged(_isComplete);
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.interaction.title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _primaryText(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.interaction.prompt,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: _secondaryText(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderExperiment(BuildContext context) {
    final valueLabel = widget.interaction.valueLabel ?? 'Value';
    final unit = widget.interaction.valueUnit ?? '';
    final outputLabel = widget.interaction.outputLabel;
    final output = _value * widget.interaction.outputMultiplier;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$valueLabel: ${_value.toStringAsFixed(1)}$unit',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: _primaryText(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        Slider(
          value: _value,
          min: widget.interaction.minValue,
          max: widget.interaction.maxValue,
          onChanged: (newValue) {
            setState(() {
              _value = newValue;
            });
            _notifyCompletion();
          },
        ),
        if (outputLabel != null)
          Text(
            '$outputLabel: ${output.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: _secondaryText(context),
            ),
          ),
      ],
    );
  }

  Widget _buildChartExperiment(BuildContext context) {
    final output = _chartInput * widget.interaction.outputMultiplier;
    final normalized =
        (output /
                (widget.interaction.maxValue *
                    widget.interaction.outputMultiplier))
            .clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.interaction.valueLabel ?? 'Input'}: ${_chartInput.toStringAsFixed(1)}${widget.interaction.valueUnit ?? ''}',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: _primaryText(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        Slider(
          value: _chartInput,
          min: widget.interaction.minValue,
          max: widget.interaction.maxValue,
          onChanged: (newValue) {
            setState(() {
              _chartInput = newValue;
            });
            _notifyCompletion();
          },
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: normalized,
            minHeight: 12,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${widget.interaction.outputLabel ?? 'Output'}: ${output.toStringAsFixed(2)}',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: _secondaryText(context),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleChoiceExperiment(BuildContext context) {
    final options = widget.interaction.options ?? const <String>[];
    final correctOption = widget.interaction.correctOption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _toggleOn,
          title: Text(
            widget.interaction.toggleLabel ?? 'Enable scenario',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: _primaryText(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          onChanged: (enabled) {
            setState(() {
              _toggleOn = enabled;
            });
            _notifyCompletion();
          },
        ),
        for (final option in options)
          RadioListTile<String>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: option,
            groupValue: _selectedOption,
            title: Text(
              option,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: _primaryText(context),
              ),
            ),
            onChanged: _toggleOn
                ? (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                    _notifyCompletion();
                  }
                : null,
          ),
        if (_selectedOption != null && !_isComplete && correctOption != null)
          Text(
            'Try again: think about the bonding rule before continuing.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: context.appColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildDragArrangement(BuildContext context) {
    final draggableOptions =
        widget.interaction.draggableOptions ?? const <String>[];
    final expectedOrder = widget.interaction.expectedOrder ?? const <String>[];
    final availableOptions = List<String>.from(draggableOptions)
      ..removeWhere((item) => _dragPlaced.contains(item));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableOptions.map((item) {
            return Draggable<String>(
              data: item,
              feedback: Material(
                color: Colors.transparent,
                child: Chip(label: Text(item)),
              ),
              childWhenDragging: Chip(
                label: Text(
                  item,
                  style: TextStyle(color: _secondaryText(context)),
                ),
              ),
              child: Chip(label: Text(item)),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < expectedOrder.length; i++) ...[
          DragTarget<String>(
            onAcceptWithDetails: (details) {
              setState(() {
                _isDragSkipped = false;
                _dragPlaced[i] = details.data;
              });
              _notifyCompletion();
            },
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTap: _dragPlaced[i] == null
                    ? null
                    : () {
                        setState(() {
                          _isDragSkipped = false;
                          _dragPlaced[i] = null;
                        });
                        _notifyCompletion();
                      },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Text(
                    _dragPlaced[i] == null
                        ? 'Drop item for slot ${i + 1}'
                        : 'Slot ${i + 1}: ${_dragPlaced[i]} (tap to remove)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: _primaryText(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
        Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isDragSkipped = false;
                  _dragPlaced = List<String?>.filled(
                    expectedOrder.length,
                    null,
                  );
                });
                _notifyCompletion();
              },
              child: const Text('Reset arrangement'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isDragSkipped = true;
                  _dragPlaced = List<String?>.from(expectedOrder);
                });
                _notifyCompletion();
              },
              icon: const Icon(Icons.skip_next_rounded),
              label: const Text('Skip'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final interaction = widget.interaction;

    Widget body;
    switch (interaction.type) {
      case LessonInteractionType.sliderExperiment:
        body = _buildSliderExperiment(context);
        break;
      case LessonInteractionType.dragArrangement:
        body = _buildDragArrangement(context);
        break;
      case LessonInteractionType.toggleChoiceExperiment:
        body = _buildToggleChoiceExperiment(context);
        break;
      case LessonInteractionType.chartExperiment:
        body = _buildChartExperiment(context);
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          body,
          if (_isComplete && interaction.revealOnComplete != null) ...[
            const SizedBox(height: 8),
            Text(
              interaction.revealOnComplete!,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: context.appColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LessonsScreen extends StatefulWidget {
  final List<Lesson> lessons;
  final Color? themeColor;

  const LessonsScreen({super.key, required this.lessons, this.themeColor});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  int _selectedLessonIndex = 0;
  Map<String, LessonProgressStatus> _lessonStatuses = const {};

  @override
  void initState() {
    super.initState();
    _refreshLessonStatuses();
  }

  Future<void> _refreshLessonStatuses() async {
    final titles = widget.lessons.map((lesson) => lesson.title).toList();
    final statuses = await ProgressManager.getLessonProgressStatuses(titles);
    if (!mounted) {
      return;
    }
    setState(() {
      _lessonStatuses = statuses;
    });
  }

  Widget _buildStatusBadge(LessonProgressStatus? status) {
    final hasQuiz = status?.quizCompleted == true;
    final hasReadOnly = status?.lessonRead == true && !hasQuiz;

    if (!hasQuiz && !hasReadOnly) {
      return const SizedBox.shrink();
    }

    final label = hasQuiz ? 'Quiz done' : 'Read only';
    final bgColor = hasQuiz
        ? const Color(0xFF1F9D63).withValues(alpha: 0.14)
        : const Color(0xFF4B6A9B).withValues(alpha: 0.14);
    final fgColor = hasQuiz ? const Color(0xFF15784B) : const Color(0xFF2F4F79);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1000;
    final selectedLesson = widget.lessons[_selectedLessonIndex];

    if (isWide) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lessons'),
          actions: const [ThemeToggleButton()],
        ),
        body: Row(
          children: [
            SizedBox(
              width: 360,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.lessons.length,
                itemBuilder: (context, index) {
                  final lesson = widget.lessons[index];
                  final isSelected = index == _selectedLessonIndex;
                  final status = _lessonStatuses[lesson.title];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.16)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest
                              : widget.themeColor),
                    child: ListTile(
                      selected: isSelected,
                      leading: lesson.imagePath != null
                          ? Image.asset(
                              lesson.imagePath!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.menu_book_rounded, size: 28),
                      title: Text(
                        lesson.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.72),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildStatusBadge(status),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedLessonIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
            Expanded(
              child: LessonDetailBody(
                key: ValueKey(selectedLesson.title),
                lesson: selectedLesson,
                themeColor: widget.themeColor,
                showBackButton: false,
                onProgressUpdated: _refreshLessonStatuses,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.lessons.length,
        itemBuilder: (context, index) {
          final lesson = widget.lessons[index];
          final status = _lessonStatuses[lesson.title];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : widget.themeColor,
            child: ListTile(
              leading: lesson.imagePath != null
                  ? Image.asset(
                      lesson.imagePath!,
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.menu_book_rounded, size: 30),
              title: Text(
                lesson.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                lesson.description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusBadge(status),
                  if (status?.quizCompleted != true &&
                      status?.lessonRead != true)
                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                ],
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailScreen(
                      lesson: lesson,
                      themeColor: widget.themeColor,
                      onProgressUpdated: _refreshLessonStatuses,
                    ),
                  ),
                );
                _refreshLessonStatuses();
              },
            ),
          );
        },
      ),
    );
  }
}
