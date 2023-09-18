import 'package:classinsights/models/ethernet_data.dart';

class ComputerData {
  final List<double> powerConsumption;
  final double ramUsage;
  final List<List<double>> cpuUsage;
  final double diskUsage;
  final List<EthernetData> ethernetData;

  const ComputerData({
    required this.powerConsumption,
    required this.ramUsage,
    required this.cpuUsage,
    required this.diskUsage,
    required this.ethernetData,
  });
}
