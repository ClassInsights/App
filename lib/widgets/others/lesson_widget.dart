import 'dart:async';

import 'package:classinsights/models/lesson.dart';
import 'package:classinsights/providers/classes_provider.dart';
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

class _LessonWidgetState extends ConsumerState<LessonWidget> with WidgetsBindingObserver {
  int currentIndex = 0;
  List<Lesson?> lessons = [];
  DateTime now = DateTime.now();
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      setState(() => now = DateTime.now());
      final currentLessons = ref.read(lessonProvider.notifier).getCurrentLesson(roomId: widget.roomId);
      if (currentLessons.isEmpty) {
        if (lessons.isEmpty) setState(() => lessons = []);
        return;
      }
      if (currentLessons.every((lesson) => lessons.contains(lesson))) return;
      setState(() => lessons = currentLessons);
    });
  }

  @override
  void initState() {
    super.initState();
    lessons = ref.read(lessonProvider.notifier).getCurrentLesson(roomId: widget.roomId);
    startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startTimer();
    } else if (state == AppLifecycleState.paused) {
      timer.cancel();
    }
  }

  void updateIndex(int newIndex) {
    setState(() => currentIndex = newIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      final todaysLessons = ref.read(lessonProvider.notifier).getLessonsForDay(now, roomId: widget.roomId);
      if (todaysLessons.isEmpty) {
        return const ContainerWithContent(
          label: "Aktuelle Stunde",
          title: "Keine Stunden heute",
        );
      }

      if (todaysLessons.first.startTime?.isAfter(now) == true) {
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
      final nextLesson = todaysLessons.elementAtOrNull(todaysLessons.indexOf(previousLesson) + 1);
      final nextLessonStart = nextLesson?.startTime;
      final previousLessonEnd = previousLesson.endTime;

      if (nextLesson == null || nextLessonStart == null || previousLessonEnd == null) {
        return const ContainerWithContent(
          label: "Aktuelle Stunde",
          title: "unerwarteter Fehler",
        );
      }

      final baseSeconds = nextLessonStart.difference(previousLessonEnd).inSeconds;
      final secondsPassed = now.difference(previousLessonEnd).inSeconds;

      if (baseSeconds > 60 * 50) {
        return const ContainerWithContent(
          label: "Aktuelle Stunde",
          title: "Gerade keine Stunde",
        );
      }

      return ContainerWithContent(
        label: "Nächste Stunde",
        title: nextLesson.subject.name,
        child: ProgressBar(
          title: 'in ${((baseSeconds - secondsPassed) / 60).ceil().toStringAsFixed(0)} Minuten',
          progress: secondsPassed,
          baseValue: baseSeconds,
        ),
      );
    }

    final startTime = lessons.elementAtOrNull(currentIndex)?.startTime;
    final endTime = lessons.elementAtOrNull(currentIndex)?.endTime;

    if (startTime == null || endTime == null) return const SizedBox.shrink();

    final baseSeconds = endTime.difference(startTime).inSeconds;
    final seconds = now.difference(startTime).inSeconds;

    final lesson = lessons.elementAtOrNull(currentIndex);
    final className = widget.roomId != null ? ref.read(classesProvider.notifier).findClassById(lessons[currentIndex]?.classId ?? -1)?.name : null;

    if (lesson == null) return const SizedBox.shrink();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity;
        if (velocity == null) return;
        if (velocity > 0) {
          if (currentIndex == 0) return;
          updateIndex(currentIndex - 1);
        } else {
          if (currentIndex == lessons.length - 1) return;
          updateIndex(currentIndex + 1);
        }
      },
      child: ContainerWithContent(
        label: "Aktuelle Stunde",
        title: "${lesson.subject.longName.length < 10 ? lesson.subject.longName : lesson.subject.name} ${className != null ? "($className)" : ""}",
        pages: lessons.length,
        currentIndex: currentIndex,
        child: ProgressBar(
          title: 'noch ${((baseSeconds - seconds) / 60).ceil().toStringAsFixed(0)} Minuten',
          progress: seconds,
          baseValue: baseSeconds,
        ),
      ),
    );
  }
}
