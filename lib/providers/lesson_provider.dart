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

  List<Lesson> getCurrentLesson({int? roomId}) {
    final now = DateTime.now();
    if (roomId != null) {
      try {
        return lessons.where((lesson) {
          final startTime = lesson.startTime;
          final endTime = lesson.endTime;
          if (startTime == null || endTime == null) return false;

          return lesson.roomId == roomId && startTime.isBefore(now) && endTime.isAfter(now);
        }).toList();
      } catch (e) {
        return [];
      }
    }

    final classes = ref.read(authProvider).data.schoolClasses;
    if (classes.isEmpty) return [];

    try {
      return lessons.where((lesson) {
        final startTime = lesson.startTime;
        final endTime = lesson.endTime;
        if (startTime == null || endTime == null) return false;

        if (roomId != null) return lesson.roomId == roomId && startTime.isBefore(now) && endTime.isAfter(now);
        return classes.contains(lesson.classId) && startTime.isBefore(now) && endTime.isAfter(now);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  List<Lesson> getLessonsForDay(DateTime targetDay, {int? roomId}) {
    final classes = ref.read(authProvider).data.schoolClasses;
    if (classes.isEmpty) {
      if (roomId == null) return [];
      return lessons.where((lesson) => lesson.roomId == roomId).toList();
    }
    return lessons.where((lesson) {
      if (roomId != null) {
        return lesson.roomId == roomId;
      } else {
        return classes.contains(lesson.classId);
      }
    }).toList();
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

    lessons.sort((Lesson a, Lesson b) {
      if (a.startTime == null || b.startTime == null) return 0;
      return a.startTime!.compareTo(b.startTime!);
    });

    if (lessons.isNotEmpty) state = lessons;
    return lessons;
  }
}
