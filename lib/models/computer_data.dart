import 'package:classinsights/models/ethernet_data.dart';

class ComputerData {
  final double powerConsumption;
  final double ramUsage;
  final double cpuUsage;
  final double diskUsage;
  final EthernetData ethernetData;

  const ComputerData({
    required this.powerConsumption,
    required this.ramUsage,
    required this.cpuUsage,
    required this.diskUsage,
    required this.ethernetData,
  });
}
