import 'package:classinsights/widgets/container_content.dart';
import 'package:classinsights/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class LessonWidget extends StatelessWidget {
  final String subject;
  final String startTime;
  final String endTime;

  const LessonWidget({required this.subject, required this.startTime, required this.endTime, super.key});

  @override
  Widget build(BuildContext context) {
    final baseMinutes = DateTime.parse(endTime).difference(DateTime.parse(startTime)).inMinutes.toDouble();
    // final minutes = DateTime.now().difference(DateTime.parse(startTime)).inMinutes.toDouble();
    final minutes = DateTime.parse("2023-06-22T10:06:00.000Z").difference(DateTime.parse(startTime)).inMinutes.toDouble();

    return ContainerWithContent(
      label: "Aktuelle Stunde",
      title: subject,
      child: ProgressBar(
        title: 'noch ${(baseMinutes - minutes).toStringAsFixed(0)} Minuten',
        progress: minutes,
        baseValue: baseMinutes,
      ),
    );
  }
}
