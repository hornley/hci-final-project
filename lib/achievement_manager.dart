import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:hci_final_project/data/avatar_catalog.dart';
import 'package:hci_final_project/data/achievement.dart';
import 'package:hci_final_project/local_storage.dart';
import 'package:hci_final_project/progress_manager.dart';

class AchievementManager extends ChangeNotifier {
  AchievementManager._internal() {
    _init();
  }

  static final AchievementManager _instance = AchievementManager._internal();
  factory AchievementManager() => _instance;

  final List<Achievement> _achievements = [
    Achievement(
      id: 'unlock_all_avatars',
      title: 'Unlock All Avatars',
      description: 'Collect every avatar available in the app.',
      assetPath: 'assets/achievements/unlock_all_avatars.png',
    ),
    Achievement(
      id: 'reach_level_10',
      title: 'Reach Level 10',
      description: 'Achieve player level 10 through experience gains.',
      assetPath: 'assets/achievements/reach_level_10.png',
    ),
    Achievement(
      id: 'linear_algebra',
      title: 'Linear Algebra',
      description: 'Complete the linear algebra lesson/quest series.',
      assetPath: 'assets/achievements/linear.png',
    ),
    Achievement(
      id: 'integral_calculus',
      title: 'Integral Calculus',
      description: 'Finish the integral calculus lesson/quest series.',
      assetPath: 'assets/achievements/calculus.png',
    ),
    Achievement(
      id: 'physics',
      title: 'Physics',
      description: 'Complete the physics subject module.',
      assetPath: 'assets/achievements/physics.png',
    ),
    Achievement(
      id: 'chemistry',
      title: 'Chemistry',
      description: 'Finish the chemistry subject module.',
      assetPath: 'assets/achievements/chemistry.png',
    ),
    Achievement(
      id: 'first_steps',
      title: 'First Steps',
      description: 'Complete your first lesson.',
      assetPath: 'assets/achievements/first_step.png',
    ),
    Achievement(
      id: 'lesson_streak_7',
      title: 'Lesson Streak — 7 Days',
      description: 'Finish at least one lesson per day for 7 consecutive days.',
      assetPath: 'assets/achievements/lesson_streak_7 days.png',
    ),
    Achievement(
      id: 'quiz_novice',
      title: 'Quiz Novice',
      description: 'Pass your first quiz.',
      assetPath: 'assets/achievements/quiz_novice.png',
    ),
    Achievement(
      id: 'quiz_master',
      title: 'Quiz Master',
      description: 'Score 75%+ on 10 quizzes.',
      assetPath: 'assets/achievements/quiz_master.png',
    ),
    Achievement(
      id: 'perfect_quiz',
      title: 'Perfect Quiz',
      description: 'Score 100% on a quiz.',
      assetPath: 'assets/achievements/perfect_quiz.png',
    ),
    Achievement(
      id: 'topic_completer',
      title: 'Topic Completer',
      description: 'Finish all lessons in any single subject.',
      assetPath: 'assets/achievements/topic_completer.png',
    ),
    Achievement(
      id: 'achievement_hoarder',
      title: 'Achievement Hoarder',
      description: 'Earn 10 other achievements.',
      assetPath: 'assets/achievements/achievements_hoarder.png',
    ),
  ];

  final Set<String> _completed = {};
  final List<Achievement> _pendingUnlocked = [];
  bool _initialized = false;

  Achievement? get lastUnlocked =>
      _pendingUnlocked.isEmpty ? null : _pendingUnlocked.last;

  List<Achievement> get achievements => List.unmodifiable(_achievements);

  Future<void> _init() async {
    final completed = await LocalStorage.getCompletedAchievements();
    _completed.clear();
    _completed.addAll(completed);
    _initialized = true;
    notifyListeners();
  }

  Future<void> _ensureLoaded() async {
    if (_initialized) return;
    final completed = await LocalStorage.getCompletedAchievements();
    _completed
      ..clear()
      ..addAll(completed);
    _initialized = true;
  }

  bool isCompleted(String id) => _completed.contains(id);

  Future<void> markCompleted(String id) async {
    await _ensureLoaded();
    if (_completed.contains(id)) return;
    _completed.add(id);
    await LocalStorage.markAchievementCompleted(id);
    final unlocked = _achievements.firstWhere(
      (a) => a.id == id,
      orElse: () =>
          Achievement(id: id, title: id, description: '', assetPath: ''),
    );
    _pendingUnlocked.add(unlocked);
    notifyListeners();
  }

  Future<void> evaluateAndUnlock({String? recentLessonTitle}) async {
    await _ensureLoaded();

    final level = await LocalStorage.getLevel();
    if (level >= 10) {
      await markCompleted('reach_level_10');
    }

    final unlockedAvatars = await LocalStorage.getUnlockedAvatarIndices();
    if (unlockedAvatars.length >= avatarCatalog.length) {
      await markCompleted('unlock_all_avatars');
    }

    final readLessonsCount = await ProgressManager.getReadLessonsCount();
    if (readLessonsCount >= 1) {
      await markCompleted('first_steps');
    }

    final hasPassingQuiz = recentLessonTitle != null
        ? await ProgressManager.hasPassingQuizScore(
            lessonTitle: recentLessonTitle,
          )
        : await ProgressManager.hasPassingQuizScore();
    if (hasPassingQuiz) {
      await markCompleted('quiz_novice');
    }

    final qualifiedQuizCompletions =
        await ProgressManager.getQuizMasterQualifiedCompletions();
    if (qualifiedQuizCompletions >= 10) {
      await markCompleted('quiz_master');
    }

    final hasPerfectQuiz = recentLessonTitle != null
        ? await ProgressManager.hasPerfectQuizScore(recentLessonTitle)
        : await ProgressManager.hasAnyPerfectQuizScore();
    if (hasPerfectQuiz) {
      await markCompleted('perfect_quiz');
    }

    final snapshot = await ProgressManager.getProgressSnapshot();
    final subjects = {for (final s in snapshot.subjects) s.subjectTitle: s};

    bool isSubjectComplete(String title) {
      final subject = subjects[title];
      if (subject == null) return false;
      return subject.totalLessons > 0 &&
          subject.completedLessons >= subject.totalLessons;
    }

    if (isSubjectComplete('Linear Algebra')) {
      await markCompleted('linear_algebra');
    }
    if (isSubjectComplete('Integral Calculus')) {
      await markCompleted('integral_calculus');
    }
    if (isSubjectComplete('Physics')) {
      await markCompleted('physics');
    }
    if (isSubjectComplete('Chemistry')) {
      await markCompleted('chemistry');
    }

    final topicCompleter = snapshot.subjects.any(
      (subject) =>
          subject.totalLessons > 0 &&
          subject.completedLessons >= subject.totalLessons,
    );
    if (topicCompleter) {
      await markCompleted('topic_completer');
    }

    final hasStreak = await ProgressManager.hasLessonStreakDays(7);
    if (hasStreak) {
      await markCompleted('lesson_streak_7');
    }

    final unlockedOtherAchievements = _completed
        .where((id) => id != 'achievement_hoarder')
        .length;
    if (unlockedOtherAchievements >= 10) {
      await markCompleted('achievement_hoarder');
    }
  }

  void clearLastUnlocked() {
    if (_pendingUnlocked.isNotEmpty) {
      _pendingUnlocked.removeLast();
    }
  }

  List<Achievement> takePendingUnlocked() {
    if (_pendingUnlocked.isEmpty) {
      return const [];
    }
    final items = List<Achievement>.from(_pendingUnlocked);
    _pendingUnlocked.clear();
    return items;
  }

  Future<void> showPendingCompletionPopups(BuildContext context) async {
    final pending = takePendingUnlocked();
    for (final achievement in pending) {
      await showCompletionPopup(context, achievement);
    }
  }

  Achievement? findById(String id) {
    try {
      return _achievements.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // Helper to show a completion popup using the trophy animation
  Future<void> showCompletionPopup(
    BuildContext context,
    Achievement achievement,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: Lottie.asset('assets/animations/achievements_trophy.json'),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(achievement.description, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
