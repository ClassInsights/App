import 'dart:convert';

import 'package:classinsights/helpers/custom_http_client.dart';
import 'package:classinsights/models/lesson.dart';
import 'package:classinsights/models/subject_data.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/ratelimit_provider.dart';
import 'package:classinsights/providers/subject_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lessonProvider = StateNotifierProvider<LessonNotifier, List<Lesson>>((ref) => LessonNotifier(ref));

class LessonNotifier extends StateNotifier<List<Lesson>> {
  final StateNotifierProviderRef ref;
  LessonNotifier(this.ref) : super([]);

  List<Lesson> get lessons => state;

  Lesson? getLessonByDate(DateTime date) {
    final classId = ref.read(authProvider).data.schoolClass?.id;
    if (classId == null) return null;
    final userLessons = lessons.where((lesson) => lesson.classId == ref.read(authProvider).data.schoolClass?.id).toList();
    try {
      return userLessons.firstWhere((lesson) {
        if (lesson.startTime == null || lesson.endTime == null) return false;
        return lesson.startTime!.isBefore(date) && lesson.endTime!.isAfter(date);
      });
    } catch (_) {
      return null;
    }
  }

  List<Lesson> getLessonsForDay(DateTime targetDay) {
    final classId = ref.read(authProvider).data.schoolClass?.id;
    if (classId == null) return [];
    final userLessons = lessons.where((lesson) => lesson.classId == classId);

    return userLessons
        .where((lesson) =>
            lesson.startTime?.day == targetDay.day && lesson.startTime?.month == targetDay.month && lesson.startTime?.year == targetDay.year)
        .toList();
  }

  Future<void> refreshLessons() async {
    final ratelimit = ref.read(ratelimitProvider.notifier);
    if (ratelimit.isRateLimited("lessons")) return;
    ratelimit.addRateLimit("lessons");
    state = await fetchLessons(skipStateCheck: true);
  }

  Future<List<Lesson>> fetchLessons({bool skipStateCheck = false}) async {
    final token = ref.read(authProvider).creds.accessToken;
    if (token.isEmpty) return [];
    if (!skipStateCheck && state.isNotEmpty) return state;

    final client = await CustomHttpClient.create();
    final response = await client.get("/lessons");

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final List<Lesson> lessons = data.map<Lesson>((lesson) {
      final subjectId = lesson["subjectId"];
      final subjectName = ref.read(subjectProvider.notifier).getSubjectById(subjectId ?? 0);
      return Lesson(
        id: lesson["lessonId"],
        roomId: lesson["roomId"],
        subject: SubjectData(
          id: subjectId,
          name: subjectName != null ? subjectName.name : "Unbekanntes Fach",
        ),
        classId: lesson["classId"],
        startTime: DateTime.parse(lesson["startTime"].toString()),
        endTime: DateTime.parse(lesson["endTime"].toString()),
      );
    }).toList();

    if (lessons.isNotEmpty) state = lessons;
    return lessons;
  }
}
