import 'package:classinsights/models/lesson.dart';
import 'package:classinsights/widgets/container_content.dart';
import 'package:classinsights/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class LessonWidget extends StatelessWidget {
  final Lesson lesson;

  const LessonWidget({required this.lesson, super.key});

  @override
  Widget build(BuildContext context) {
    if (lesson.endTime == null || lesson.startTime == null) return const SizedBox.shrink();
    final baseMinutes = lesson.endTime!.difference(lesson.startTime!).inMinutes.toDouble();
    final minutes = DateTime.now().difference(lesson.startTime!).inMinutes.toDouble();

    return ContainerWithContent(
      label: "Aktuelle Stunde",
      title: lesson.subject.name,
      child: ProgressBar(
        title: 'noch ${(baseMinutes - minutes).toStringAsFixed(0)} Minuten',
        progress: minutes,
        baseValue: baseMinutes,
      ),
    );
  }
}