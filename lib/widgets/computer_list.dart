import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/providers/computer_provider.dart';
import 'package:classinsights/widgets/computer_widget.dart';
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
              return ComputerWidget(computer);
            },
          )
        : const Text("Keine Computer registriert");
  }
}
