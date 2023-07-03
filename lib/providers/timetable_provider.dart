import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classinsights/models/lesson.dart';

class TimetableNotifier extends StateNotifier<List<Lesson>> {
  TimetableNotifier() : super([]);

  List<Lesson> get lessons => state;
}

final timetableProvider =
    StateNotifierProvider<TimetableNotifier, List<Lesson>>(
        (ref) => TimetableNotifier());
