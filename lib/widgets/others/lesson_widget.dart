import 'dart:async';
import 'dart:convert';

import 'package:classinsights/helpers/custom_http_client.dart';
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

class _LessonWidgetState extends ConsumerState<LessonWidget> with WidgetsBindingObserver {
  Lesson? lesson;
  String? className;
  DateTime now = DateTime.now();
  late Timer timer;

  Future<String?> fetchClass(int classId) async {
    final client = await CustomHttpClient.create();
    final response = await client.get("/classes/$classId");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["name"];
    }
    return null;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      setState(() => now = DateTime.now());
      final currentLesson = ref.read(lessonProvider.notifier).getCurrentLesson(roomId: widget.roomId);
      if (currentLesson == null) {
        if (lesson != null) setState(() => lesson = null);
        return;
      }
      if (currentLesson.id == (lesson?.id ?? -1)) return;
      setState(() => lesson = currentLesson);
    });
  }

  @override
  void initState() {
    super.initState();
    lesson = ref.read(lessonProvider.notifier).getCurrentLesson(roomId: widget.roomId);
    startTimer();
    final classId = lesson?.classId;
    if (widget.roomId != null && classId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final name = await fetchClass(classId);
        if (name != null) setState(() => className = name);
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if (timer.isActive) timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startTimer();
    } else if (state == AppLifecycleState.paused) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: "${lesson?.subject.name ?? "Fach nicht gefunden"}${className != null ? " ($className)" : ""}",
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

    final nextLessonStart = todaysLessons[todaysLessons.indexOf(previousLesson) + 1].startTime; // ES KRACHT UND PFEIFT
    final previousLessonEnd = previousLesson.endTime;

    if (nextLessonStart == null || previousLessonEnd == null) {
      return const ContainerWithContent(
        label: "Aktuelle Stunde",
        title: "unerwarteter Fehler",
      );
    }

    final baseSeconds = nextLessonStart.difference(previousLessonEnd).inSeconds;
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
