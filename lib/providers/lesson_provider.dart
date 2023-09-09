import 'dart:convert';

import 'package:classinsights/models/lesson.dart';
import 'package:classinsights/models/subject_data.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/subject_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;

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

  Future<List<Lesson>> fetchLessons() async {
    final token = ref.read(authProvider).creds.accessToken;
    if (token.isEmpty) return [];
    if (state.isNotEmpty) return state;
    final client = http.Client();
    final response = await client.get(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/lessons"),
      headers: {
        "Authorization": "Bearer ${ref.read(authProvider).creds.accessToken}",
      },
    );
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
