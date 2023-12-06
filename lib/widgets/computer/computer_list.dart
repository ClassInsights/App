import 'package:classinsights/main.dart';
import 'package:classinsights/providers/computer_provider.dart';
import 'package:classinsights/widgets/computer/computer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComputerList extends ConsumerStatefulWidget {
  final int roomId;
  const ComputerList(this.roomId, {super.key});

  @override
  ConsumerState<ComputerList> createState() => _ComputerListState();
}

class _ComputerListState extends ConsumerState<ComputerList> {
  var loading = true;

  @override
  void initState() {
    ref.read(computerProvider.notifier).fetchComputers(widget.roomId).then(
          (response) => setState(() => loading = false),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final computers = ref.watch(computerProvider).where((computer) => computer.roomId == widget.roomId).toList();
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
