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
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () => onBack(),
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
                leadingWidth: 40.0,
                pinned: true,
                title: Text(
                  "OG2-DV3",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              const SliverToBoxAdapter(
                child: Column(children: [
                  SizedBox(height: 20.0),
                  LessonWidget(
                    title: "MAM",
                    startTime: "2023-06-22T09:30:00.000Z",
                    endTime: "2023-06-22T10:20:00.000Z",
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
