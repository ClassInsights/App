import 'package:classinsights/models/computer_data.dart';
import 'package:classinsights/models/ethernet_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final computerDataProvider = StateNotifierProvider((ref) => ComputerDataNotifier());

const emptyData = ComputerData(
  powerConsumption: 1,
  ramUsage: 1,
  cpuUsage: 1,
  diskUsage: 1,
  ethernetData: EthernetData(downloadSpeed: 1, uploadSpeed: 1),
);

class ComputerDataNotifier extends StateNotifier<List<ComputerData>> {
  ComputerDataNotifier() : super([emptyData]);

  void addComputerData(ComputerData data) {
    if (state.length >= 40) state.removeAt(0);
    state = [...state, data];
  }

  void clearComputerData() {
    debugPrint("Clearing computer data");
    state = [emptyData];
  }
}
