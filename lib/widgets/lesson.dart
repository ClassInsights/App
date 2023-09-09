import 'package:classinsights/models/lesson.dart';
import 'package:classinsights/widgets/container_content.dart';
import 'package:classinsights/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class LessonWidget extends StatelessWidget {
  final Lesson lesson;

  const LessonWidget({required this.lesson, super.key});

  @override
  Widget build(BuildContext context) {
    final baseMinutes = lesson.endTime.difference(lesson.startTime).inMinutes.toDouble();
    // final minutes = DateTime.now().difference(DateTime.parse(startTime)).inMinutes.toDouble();
    final minutes = DateTime.parse("2023-06-28T05:45:00").difference(lesson.startTime).inMinutes.toDouble();

    return ContainerWithContent(
      label: "Aktuelle Stunde",
      title: "FACH",
      child: ProgressBar(
        title: 'noch ${(baseMinutes - minutes).toStringAsFixed(0)} Minuten',
        progress: minutes,
        baseValue: baseMinutes,
      ),
    );
  }
}
