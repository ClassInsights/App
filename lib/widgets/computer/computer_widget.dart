import 'package:classinsights/main.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/screens/computer_detail_screen.dart';
import 'package:classinsights/widgets/computer/computer_detail_item.dart';
import 'package:classinsights/widgets/container/container_content.dart';
import 'package:flutter/material.dart';

class ComputerWidget extends StatelessWidget {
  final Computer computer;
  const ComputerWidget(this.computer, {super.key});

  @override
  Widget build(BuildContext context) {
    final computerData = [
      ComputerDetailItem(
        icon: Icons.online_prediction,
        data: computer.online ? "Online" : "Offline",
      ),
      if (computer.ipAddress != null)
        ComputerDetailItem(
          icon: Icons.network_check_rounded,
          data: computer.ipAddress!,
        ),
      if (computer.macAddress != null)
        ComputerDetailItem(
          icon: Icons.computer,
          data: computer.macAddress!,
        ),
      if (computer.lastUser != null && computer.lastUser?.startsWith("NT") == false)
        ComputerDetailItem(
          icon: Icons.person,
          data: computer.lastUser!,
        )
    ];
    return ContainerWithContent(
      onTab: () => computer.online == true
          ? Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ComputerDetailScreen(computer),
              ),
            )
          : null,
      showArrow: computer.online,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            computer.name,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (computerData.isNotEmpty) ...[
            const SizedBox(height: App.defaultPadding),
            ListView.separated(
              padding: const EdgeInsets.all(0.0),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => computerData[index],
              separatorBuilder: (context, index) => const SizedBox(
                height: App.smallPadding,
              ),
              itemCount: computerData.length,
              shrinkWrap: true,
            ),
          ],
        ],
      ),
    );
  }
}
