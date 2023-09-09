import 'dart:convert';

import 'package:classinsights/models/lesson.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;

final lessonProvider = StateNotifierProvider<LessonNotifier, List<Lesson>>((ref) => LessonNotifier(ref));

class LessonNotifier extends StateNotifier<List<Lesson>> {
  final StateNotifierProviderRef ref;
  LessonNotifier(this.ref) : super([]);

  List<Lesson> get lessons => state;

  // Lesson? getCurrentLesson() {
  //   final now = DateTime.now();
  //   final userLessons = lessons.where((lesson) => lesson.classId == ref.read(authProvider).data.schoolClass);
  //   if (lessons.any((lesson) => lesson.startTime.isBefore(now) && lesson.endTime.isAfter(now)))
  //     return lessons.firstWhere((lesson) => lesson.startTime.isBefore(now) && lesson.endTime.isAfter(now), orElse: () => null);
  // }

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
    final lessons = data.map<Lesson>((lesson) {
      return Lesson(
        id: lesson["lessonId"],
        roomId: lesson["roomId"],
        subjectId: lesson["subjectId"],
        classId: lesson["classId"],
        startTime: DateTime.parse(lesson["startTime"].toString()),
        endTime: DateTime.parse(lesson["endTime"].toString()),
      );
    }).toList();

    if (lessons.isNotEmpty) state = lessons;
    return lessons;
  }
}
