import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classinsights/models/lesson.dart';

final timetableProvider = StateNotifierProvider<TimetableNotifier, List<Lesson>>(
  (_) => TimetableNotifier(),
);

class TimetableNotifier extends StateNotifier<List<Lesson>> {
  TimetableNotifier() : super([]);

  List<Lesson> get lessons => state;

  void setLessons(List<Lesson> lessons) => state = lessons;
}
