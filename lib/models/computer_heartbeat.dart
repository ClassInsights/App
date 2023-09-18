import 'package:classinsights/models/ethernet_data.dart';

class ComputerHeartbeat {
  final double powerConsumption;
  final double ramUsage;
  final List<double> cpuUsage;
  final double diskUsage;
  final List<EthernetData> ethernetData;

  const ComputerHeartbeat({
    required this.powerConsumption,
    required this.ramUsage,
    required this.cpuUsage,
    required this.diskUsage,
    required this.ethernetData,
  });
}
