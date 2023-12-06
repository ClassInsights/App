import 'dart:async';

import 'package:classinsights/models/lesson.dart';
import 'package:classinsights/providers/lesson_provider.dart';
import 'package:classinsights/widgets/container/container_content.dart';
import 'package:classinsights/widgets/others/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonWidget extends ConsumerStatefulWidget {
  final int? roomId;
  const LessonWidget({this.roomId, super.key});

  @override
  ConsumerState<LessonWidget> createState() => _LessonWidgetState();
}

class _LessonWidgetState extends ConsumerState<LessonWidget> {
  late Lesson? lesson;
  late Timer timer;

  @override
  void initState() {
    lesson = ref.read(lessonProvider.notifier).getCurrentLesson(roomId: widget.roomId);
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (_) => setState(
        () {
          final currentLesson = ref.read(lessonProvider.notifier).getCurrentLesson(roomId: widget.roomId);
          if (currentLesson == null) {
            lesson = null;
            return;
          }
          if (currentLesson.id == (lesson?.id ?? -1)) return;
          lesson = currentLesson;
        },
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    if (lesson != null) {
      final startTime = lesson?.startTime;
      final endTime = lesson?.endTime;

      if (startTime == null || endTime == null) {
        return const ContainerWithContent(
          label: "Aktuelle Stunde",
          title: "unerwarteter Fehler",
        );
      }

      final baseSeconds = endTime.difference(startTime).inSeconds;
      final seconds = now.difference(startTime).inSeconds;

      return ContainerWithContent(
        label: "Aktuelle Stunde",
        title: lesson?.subject.name ?? "Fach nicht gefunden",
        child: ProgressBar(
          title: 'noch ${((baseSeconds - seconds) / 60).ceil().toStringAsFixed(0)} Minuten',
          progress: seconds,
          baseValue: baseSeconds,
        ),
      );
    }

    final todaysLessons = ref.read(lessonProvider.notifier).getLessonsForDay(now, roomId: widget.roomId);

    if (todaysLessons.isEmpty) {
      return const ContainerWithContent(
        label: "Aktuelle Stunde",
        title: "Keine Stunden heute",
      );
    }

    if (todaysLessons.first.startTime?.isBefore(now) == true) {
      return const ContainerWithContent(
        label: "Aktuelle Stunde",
        title: "Noch hat keine Stunde begonnen",
      );
    }

    final previousLesson = todaysLessons.reversed.firstWhere((les) {
      final endTime = les.endTime;
      if (endTime == null) return false;
      return endTime.isBefore(now);
    }, orElse: () => todaysLessons.last);

    if (previousLesson.id == todaysLessons.last.id) {
      return const ContainerWithContent(
        label: "Aktuelle Stunde",
        title: "Keine weiteren Stunden heute",
      );
    }

    final nextLessonStart = todaysLessons[todaysLessons.indexOf(previousLesson) + 1].startTime;
    final previousLessonEnd = previousLesson.endTime;

    if (nextLessonStart == null || previousLessonEnd == null) {
      return const ContainerWithContent(
        label: "Aktuelle Stunde",
        title: "unerwarteter Fehler",
      );
    }

    final baseSeconds = nextLessonStart.difference(previousLessonEnd).inMinutes;
    final secondsPassed = now.difference(previousLessonEnd).inSeconds;

    return ContainerWithContent(
      label: "Aktuelle Stunde",
      title: "Pause",
      child: ProgressBar(
        title: 'noch ${((baseSeconds - secondsPassed) / 60).ceil().toStringAsFixed(0)} Minuten',
        progress: secondsPassed,
        baseValue: baseSeconds,
      ),
    );
  }
}
