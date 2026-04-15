import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'data/lessons/chemistry.dart';
import 'data/lessons/integral_calculus.dart';
import 'data/lessons/linear_algebra.dart';
import 'data/lessons/physics.dart';
import 'local_storage.dart';
import 'models/lesson.dart';

class SubjectProgressData {
  final String subjectTitle;
  final int completedLessons;
  final int totalLessons;
  final int correctAnswers;
  final int totalQuestions;
  final int quizzesTaken;
  final double progress;

  const SubjectProgressData({
    required this.subjectTitle,
    required this.completedLessons,
    required this.totalLessons,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.quizzesTaken,
    required this.progress,
  });

  String get quizLabel => '$quizzesTaken';
}

class QuizCompletionRecord {
  final String lessonTitle;
  final String subjectTitle;
  final int correctAnswers;
  final int totalQuestions;
  final int percentage;
  final DateTime completedAt;

  const QuizCompletionRecord({
    required this.lessonTitle,
    required this.subjectTitle,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.percentage,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'lessonTitle': lessonTitle,
      'subjectTitle': subjectTitle,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory QuizCompletionRecord.fromMap(Map<String, dynamic> map) {
    return QuizCompletionRecord(
      lessonTitle: map['lessonTitle'] as String,
      subjectTitle: map['subjectTitle'] as String,
      correctAnswers: (map['correctAnswers'] as num).toInt(),
      totalQuestions: (map['totalQuestions'] as num).toInt(),
      percentage: (map['percentage'] as num).toInt(),
      completedAt: DateTime.parse(map['completedAt'] as String),
    );
  }
}

class LessonProgressStatus {
  final bool lessonRead;
  final bool quizCompleted;

  const LessonProgressStatus({
    required this.lessonRead,
    required this.quizCompleted,
  });
}

class ProgressSnapshot {
  final List<SubjectProgressData> subjects;
  final QuizCompletionRecord? recentQuiz;

  const ProgressSnapshot({required this.subjects, required this.recentQuiz});
}

class QuizRewardProgress {
  final bool baseClaimed;
  final Set<int> rewardedQuestionIndexes;

  const QuizRewardProgress({
    required this.baseClaimed,
    required this.rewardedQuestionIndexes,
  });
}

class ProgressManager {
  static const _keyPrefix = 'progressData';
  static const _guestUserKey = 'guest';

  static final Map<String, List<Lesson>> _subjectLessons = {
    'Linear Algebra': linearAlgebraLessons,
    'Integral Calculus': integralCalculusLessons,
    'Physics': physicsLessons,
    'Chemistry': chemistryLessons,
  };

  static Map<String, String> get _lessonToSubject {
    final map = <String, String>{};
    _subjectLessons.forEach((subject, lessons) {
      for (final lesson in lessons) {
        map[lesson.title] = subject;
      }
    });
    return map;
  }

  static Future<String> _userKey() async {
    final username = await LocalStorage.getCurrentUsername();
    return username ?? 'guest';
  }

  static Future<String> _storageKey() async {
    final userKey = await _userKey();
    return '$_keyPrefix-$userKey';
  }

  static Future<Map<String, dynamic>> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _storageKey();
    final raw = prefs.getString(key);
    if (raw == null) {
      return {
        'readLessons': <String>[],
        'completedLessons': <String>[],
        'rewardedQuizLessons': <String>[],
        'rewardedQuizBaseLessons': <String>[],
        'rewardedQuizQuestionIndexes': <String, dynamic>{},
        'quizStats': <String, dynamic>{},
        'recentQuizzes': <dynamic>[],
        'quizMasterQualifiedCompletions': 0,
      };
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return {
      'readLessons': List<String>.from(decoded['readLessons'] ?? []),
      'completedLessons': List<String>.from(decoded['completedLessons'] ?? []),
      'rewardedQuizLessons': List<String>.from(
        decoded['rewardedQuizLessons'] ?? [],
      ),
      'rewardedQuizBaseLessons': List<String>.from(
        decoded['rewardedQuizBaseLessons'] ??
            decoded['rewardedQuizLessons'] ??
            [],
      ),
      'rewardedQuizQuestionIndexes': Map<String, dynamic>.from(
        decoded['rewardedQuizQuestionIndexes'] ?? {},
      ),
      'quizStats': Map<String, dynamic>.from(decoded['quizStats'] ?? {}),
      'recentQuizzes': List<dynamic>.from(decoded['recentQuizzes'] ?? []),
      'quizMasterQualifiedCompletions':
          (decoded['quizMasterQualifiedCompletions'] as num?)?.toInt() ?? 0,
    };
  }

  static Future<void> _saveData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _storageKey();
    await prefs.setString(key, jsonEncode(data));
  }

  static Future<void> recordQuizCompletion({
    required String lessonTitle,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    final data = await _loadData();

    final readLessons = List<String>.from(data['readLessons'] as List);
    if (!readLessons.contains(lessonTitle)) {
      readLessons.add(lessonTitle);
    }

    final completedLessons = List<String>.from(
      data['completedLessons'] as List,
    );
    if (!completedLessons.contains(lessonTitle)) {
      completedLessons.add(lessonTitle);
    }

    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);
    final existing = Map<String, dynamic>.from(
      quizStats[lessonTitle] as Map? ?? {},
    );

    final attempts = ((existing['attempts'] as num?)?.toInt() ?? 0) + 1;
    final bestCorrect =
        ((existing['bestCorrect'] as num?)?.toInt() ?? 0) > correctAnswers
        ? (existing['bestCorrect'] as num).toInt()
        : correctAnswers;

    quizStats[lessonTitle] = {
      'attempts': attempts,
      'bestCorrect': bestCorrect,
      'lastCorrect': correctAnswers,
      'totalQuestions': totalQuestions,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    final subjectTitle = _lessonToSubject[lessonTitle] ?? 'Unknown Subject';
    final percentage = totalQuestions == 0
        ? 0
        : ((correctAnswers / totalQuestions) * 100).round();
    final quizMasterQualifiedCompletions =
        ((data['quizMasterQualifiedCompletions'] as num?)?.toInt() ?? 0) +
        (percentage >= 75 ? 1 : 0);

    final recent = List<dynamic>.from(data['recentQuizzes'] as List);
    recent.insert(
      0,
      QuizCompletionRecord(
        lessonTitle: lessonTitle,
        subjectTitle: subjectTitle,
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
        percentage: percentage,
        completedAt: DateTime.now(),
      ).toMap(),
    );

    final trimmedRecent = recent.take(10).toList();

    await _saveData({
      'readLessons': readLessons,
      'completedLessons': completedLessons,
      'rewardedQuizLessons': List<String>.from(
        data['rewardedQuizLessons'] as List,
      ),
      'rewardedQuizBaseLessons': List<String>.from(
        data['rewardedQuizBaseLessons'] as List,
      ),
      'rewardedQuizQuestionIndexes': Map<String, dynamic>.from(
        data['rewardedQuizQuestionIndexes'] as Map,
      ),
      'quizStats': quizStats,
      'recentQuizzes': trimmedRecent,
      'quizMasterQualifiedCompletions': quizMasterQualifiedCompletions,
    });
  }

  static Future<void> markLessonRead(String lessonTitle) async {
    final data = await _loadData();
    final readLessons = List<String>.from(data['readLessons'] as List);
    if (!readLessons.contains(lessonTitle)) {
      readLessons.add(lessonTitle);
      await _saveData({
        'readLessons': readLessons,
        'completedLessons': List<String>.from(data['completedLessons'] as List),
        'rewardedQuizLessons': List<String>.from(
          data['rewardedQuizLessons'] as List,
        ),
        'rewardedQuizBaseLessons': List<String>.from(
          data['rewardedQuizBaseLessons'] as List,
        ),
        'rewardedQuizQuestionIndexes': Map<String, dynamic>.from(
          data['rewardedQuizQuestionIndexes'] as Map,
        ),
        'quizStats': Map<String, dynamic>.from(data['quizStats'] as Map),
        'recentQuizzes': List<dynamic>.from(data['recentQuizzes'] as List),
        'quizMasterQualifiedCompletions':
            (data['quizMasterQualifiedCompletions'] as num?)?.toInt() ?? 0,
      });
    }
  }

  static Future<QuizRewardProgress> getQuizRewardProgress(
    String lessonTitle,
  ) async {
    final data = await _loadData();
    final baseClaimedLessons = {
      ...Set<String>.from(data['rewardedQuizLessons'] as List),
      ...Set<String>.from(data['rewardedQuizBaseLessons'] as List),
    };

    final perQuestionRaw = Map<String, dynamic>.from(
      data['rewardedQuizQuestionIndexes'] as Map,
    );
    final rewardedIndexes = Set<int>.from(
      List<dynamic>.from(
        perQuestionRaw[lessonTitle] as List? ?? const [],
      ).map((item) => (item as num).toInt()),
    );

    return QuizRewardProgress(
      baseClaimed: baseClaimedLessons.contains(lessonTitle),
      rewardedQuestionIndexes: rewardedIndexes,
    );
  }

  static Future<bool> hasPerfectQuizScore(String lessonTitle) async {
    final data = await _loadData();
    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);
    final stat = Map<String, dynamic>.from(
      quizStats[lessonTitle] as Map? ?? const {},
    );

    if (stat.isEmpty) {
      return false;
    }

    final totalQuestions = ((stat['totalQuestions'] as num?)?.toInt() ?? 0);
    final bestCorrect = ((stat['bestCorrect'] as num?)?.toInt() ?? 0);

    return totalQuestions > 0 && bestCorrect >= totalQuestions;
  }

  static Future<void> markQuizRewardProgress({
    required String lessonTitle,
    bool claimBase = false,
    Set<int> questionIndexes = const {},
  }) async {
    final data = await _loadData();

    final legacyRewarded = Set<String>.from(
      data['rewardedQuizLessons'] as List,
    );
    final baseRewarded = Set<String>.from(
      data['rewardedQuizBaseLessons'] as List,
    );
    final perQuestionRaw = Map<String, dynamic>.from(
      data['rewardedQuizQuestionIndexes'] as Map,
    );

    final existingIndexes = Set<int>.from(
      List<dynamic>.from(
        perQuestionRaw[lessonTitle] as List? ?? const [],
      ).map((item) => (item as num).toInt()),
    );

    if (claimBase) {
      legacyRewarded.add(lessonTitle);
      baseRewarded.add(lessonTitle);
    }

    if (questionIndexes.isNotEmpty) {
      existingIndexes.addAll(questionIndexes);
      perQuestionRaw[lessonTitle] = existingIndexes.toList()..sort();
    }

    await _saveData({
      'readLessons': List<String>.from(data['readLessons'] as List),
      'completedLessons': List<String>.from(data['completedLessons'] as List),
      'rewardedQuizLessons': legacyRewarded.toList(),
      'rewardedQuizBaseLessons': baseRewarded.toList(),
      'rewardedQuizQuestionIndexes': perQuestionRaw,
      'quizStats': Map<String, dynamic>.from(data['quizStats'] as Map),
      'recentQuizzes': List<dynamic>.from(data['recentQuizzes'] as List),
      'quizMasterQualifiedCompletions':
          (data['quizMasterQualifiedCompletions'] as num?)?.toInt() ?? 0,
    });
  }

  static Future<bool> hasClaimedQuizReward(String lessonTitle) async {
    final progress = await getQuizRewardProgress(lessonTitle);
    return progress.baseClaimed;
  }

  static Future<void> markQuizRewardClaimed(String lessonTitle) async {
    await markQuizRewardProgress(lessonTitle: lessonTitle, claimBase: true);
  }

  static Future<Map<String, LessonProgressStatus>> getLessonProgressStatuses(
    List<String> lessonTitles,
  ) async {
    final data = await _loadData();
    final readLessons = Set<String>.from(data['readLessons'] as List);
    final completedLessons = Set<String>.from(data['completedLessons'] as List);

    final statuses = <String, LessonProgressStatus>{};
    for (final title in lessonTitles) {
      statuses[title] = LessonProgressStatus(
        lessonRead: readLessons.contains(title),
        quizCompleted: completedLessons.contains(title),
      );
    }
    return statuses;
  }

  static Future<ProgressSnapshot> getProgressSnapshot() async {
    final data = await _loadData();
    final completedLessons = Set<String>.from(data['completedLessons'] as List);
    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);
    final recentRaw = List<dynamic>.from(data['recentQuizzes'] as List);

    final subjects = <SubjectProgressData>[];

    _subjectLessons.forEach((subjectTitle, lessons) {
      final totalLessons = lessons.length;
      var completedCount = 0;
      var correctTotal = 0;
      var questionTotal = 0;
      var quizzesTaken = 0;

      for (final lesson in lessons) {
        if (completedLessons.contains(lesson.title)) {
          completedCount++;
        }

        final stat = Map<String, dynamic>.from(
          quizStats[lesson.title] as Map? ?? const {},
        );
        if (stat.isNotEmpty) {
          // Count unique lessons attempted, not total retake attempts.
          quizzesTaken += 1;
          correctTotal += ((stat['bestCorrect'] as num?)?.toInt() ?? 0);
          questionTotal += ((stat['totalQuestions'] as num?)?.toInt() ?? 0);
        }
      }

      final lessonRatio = totalLessons == 0
          ? 0.0
          : completedCount / totalLessons;
      final progress = lessonRatio.clamp(0.0, 1.0);

      subjects.add(
        SubjectProgressData(
          subjectTitle: subjectTitle,
          completedLessons: completedCount,
          totalLessons: totalLessons,
          correctAnswers: correctTotal,
          totalQuestions: questionTotal,
          quizzesTaken: quizzesTaken,
          progress: progress,
        ),
      );
    });

    QuizCompletionRecord? recentQuiz;
    if (recentRaw.isNotEmpty) {
      recentQuiz = QuizCompletionRecord.fromMap(
        Map<String, dynamic>.from(recentRaw.first as Map),
      );
    }

    return ProgressSnapshot(subjects: subjects, recentQuiz: recentQuiz);
  }

  static Future<void> resetProgress() async {
    await _saveData({
      'readLessons': <String>[],
      'completedLessons': <String>[],
      'rewardedQuizLessons': <String>[],
      'rewardedQuizBaseLessons': <String>[],
      'rewardedQuizQuestionIndexes': <String, dynamic>{},
      'quizStats': <String, dynamic>{},
      'recentQuizzes': <dynamic>[],
      'quizMasterQualifiedCompletions': 0,
    });
  }

  static Future<int> getQuizMasterQualifiedCompletions() async {
    final data = await _loadData();
    return (data['quizMasterQualifiedCompletions'] as num?)?.toInt() ?? 0;
  }

  static Future<void> resetGuestProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix-$_guestUserKey');
    await LocalStorage.clearGuestCompletedAchievements();
  }

  static Future<int> getCompletedLessonsCount() async {
    final data = await _loadData();
    final completedLessons = Set<String>.from(data['completedLessons'] as List);
    return completedLessons.length;
  }

  static Future<int> getReadLessonsCount() async {
    final data = await _loadData();
    final readLessons = Set<String>.from(data['readLessons'] as List);
    return readLessons.length;
  }

  static Future<int> getTotalQuizAttempts() async {
    final data = await _loadData();
    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);
    var attempts = 0;

    for (final raw in quizStats.values) {
      final stat = Map<String, dynamic>.from(raw as Map? ?? const {});
      attempts += ((stat['attempts'] as num?)?.toInt() ?? 0);
    }

    return attempts;
  }

  static Future<bool> hasPassingQuizScore({String? lessonTitle}) async {
    final data = await _loadData();
    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);

    if (lessonTitle != null) {
      final stat = Map<String, dynamic>.from(
        quizStats[lessonTitle] as Map? ?? const {},
      );
      final totalQuestions = ((stat['totalQuestions'] as num?)?.toInt() ?? 0);
      final bestCorrect = ((stat['bestCorrect'] as num?)?.toInt() ?? 0);
      return totalQuestions > 0 && (bestCorrect * 2) >= totalQuestions;
    }

    for (final raw in quizStats.values) {
      final stat = Map<String, dynamic>.from(raw as Map? ?? const {});
      final totalQuestions = ((stat['totalQuestions'] as num?)?.toInt() ?? 0);
      final bestCorrect = ((stat['bestCorrect'] as num?)?.toInt() ?? 0);
      if (totalQuestions > 0 && (bestCorrect * 2) >= totalQuestions) {
        return true;
      }
    }

    return false;
  }

  static Future<int> countLessonsWithMinBestPercentage(
    int minPercentage,
  ) async {
    final data = await _loadData();
    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);
    var count = 0;

    for (final raw in quizStats.values) {
      final stat = Map<String, dynamic>.from(raw as Map? ?? const {});
      final totalQuestions = ((stat['totalQuestions'] as num?)?.toInt() ?? 0);
      final bestCorrect = ((stat['bestCorrect'] as num?)?.toInt() ?? 0);

      if (totalQuestions <= 0) continue;
      final percentage = (bestCorrect * 100) / totalQuestions;
      if (percentage >= minPercentage) {
        count++;
      }
    }

    return count;
  }

  static Future<bool> hasAnyPerfectQuizScore() async {
    final data = await _loadData();
    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);

    for (final raw in quizStats.values) {
      final stat = Map<String, dynamic>.from(raw as Map? ?? const {});
      final totalQuestions = ((stat['totalQuestions'] as num?)?.toInt() ?? 0);
      final bestCorrect = ((stat['bestCorrect'] as num?)?.toInt() ?? 0);

      if (totalQuestions > 0 && bestCorrect >= totalQuestions) {
        return true;
      }
    }

    return false;
  }

  static Future<bool> hasLessonStreakDays(int requiredDays) async {
    if (requiredDays <= 1) {
      return true;
    }

    final data = await _loadData();
    final recentRaw = List<dynamic>.from(data['recentQuizzes'] as List);
    if (recentRaw.isEmpty) {
      return false;
    }

    // Keep unique local dates with at least one completed lesson.
    final uniqueDates = <DateTime>{};
    for (final raw in recentRaw) {
      final record = QuizCompletionRecord.fromMap(
        Map<String, dynamic>.from(raw as Map),
      );
      uniqueDates.add(
        DateTime(
          record.completedAt.year,
          record.completedAt.month,
          record.completedAt.day,
        ),
      );
    }

    final sorted = uniqueDates.toList()..sort();
    if (sorted.length < requiredDays) {
      return false;
    }

    var streak = 1;
    for (var i = 1; i < sorted.length; i++) {
      final delta = sorted[i].difference(sorted[i - 1]).inDays;
      if (delta == 1) {
        streak++;
        if (streak >= requiredDays) {
          return true;
        }
      } else if (delta > 1) {
        streak = 1;
      }
    }

    return false;
  }
}
