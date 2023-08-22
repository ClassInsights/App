import 'package:classinsights/widgets/detail_appbar.dart';
import 'package:classinsights/widgets/lesson.dart';
import 'package:flutter/material.dart';

class RoomDetailScreen extends StatelessWidget {
  final String roomID;
  const RoomDetailScreen(this.roomID, {super.key});

  @override
  Widget build(BuildContext context) {
    onBack() => Navigator.of(context).pop();
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            DetailAppbar(
              title: "OG2-DV3",
              onBack: onBack,
            ),
            const SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 20.0),
                LessonWidget(
                  title: "MAM",
                  startTime: "2023-06-22T09:30:00.000Z",
                  endTime: "2023-06-22T10:20:00.000Z",
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
