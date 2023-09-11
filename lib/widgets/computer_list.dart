import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/providers/computer_provider.dart';
import 'package:classinsights/screens/computer_detail_screen.dart';
import 'package:classinsights/widgets/container_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComputerList extends ConsumerStatefulWidget {
  final int classId;
  const ComputerList(this.classId, {super.key});

  @override
  ConsumerState<ComputerList> createState() => _ComputerListState();
}

class _ComputerListState extends ConsumerState<ComputerList> {
  var loading = true;
  List<Computer> computers = [];

  @override
  void initState() {
    ref.read(computerProvider.notifier).fetchComputers(widget.classId).then(
          (response) => setState(() {
            loading = false;
            computers = response;
          }),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return computers.isNotEmpty
        ? ListView.separated(
            padding: const EdgeInsets.all(0.0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: computers.length,
            shrinkWrap: true,
            separatorBuilder: (context, _) => const SizedBox(
              height: App.defaultPadding,
            ),
            itemBuilder: (context, index) {
              final computer = computers[index];
              return ContainerWithContent(
                label: "Computer",
                title: computer.name,
                showArrow: true,
                onTab: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, firstAnimation, secondAnimation) => ComputerDetailScreen(computer),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
              );
            },
          )
        : const Text("Keine Computer registriert");
  }
}
