import 'dart:async';

import 'package:classinsights/models/lesson.dart';
import 'package:classinsights/widgets/container/container_content.dart';
import 'package:classinsights/widgets/others/progress_bar.dart';
import 'package:flutter/material.dart';

class LessonWidget extends StatefulWidget {
  final Lesson lesson;

  const LessonWidget({required this.lesson, super.key});

  @override
  State<LessonWidget> createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget> {
  late Timer timer;
  var now = DateTime.now();

  void update() => setState(() => now = DateTime.now());

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) => update());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.endTime == null || widget.lesson.startTime == null) return const SizedBox.shrink();
    final baseMinutes = widget.lesson.endTime!.difference(widget.lesson.startTime!).inMinutes.toDouble();
    final minutes = now.difference(widget.lesson.startTime!).inMinutes.toDouble();

    return ContainerWithContent(
      label: "Aktuelle Stunde",
      title: widget.lesson.subject.name,
      child: ProgressBar(
        title: 'noch ${(baseMinutes - minutes).toStringAsFixed(0)} Minuten',
        progress: minutes,
        baseValue: baseMinutes,
      ),
    );
  }
}
