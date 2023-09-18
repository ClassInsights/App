class ComputerData {
  final List<double> powerConsumption;
  final List<double> ramUsage;
  final List<List<double>> cpuUsage;
  final double diskUsage;
  final List<List<double>> ethernetData;

  const ComputerData({
    required this.powerConsumption,
    required this.ramUsage,
    required this.cpuUsage,
    required this.diskUsage,
    required this.ethernetData,
  });
}
