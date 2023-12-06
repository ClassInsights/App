import 'package:classinsights/models/computer_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final computerDataProvider = StateNotifierProvider((ref) => ComputerDataNotifier());

class ComputerDataNotifier extends StateNotifier<List<ComputerData>> {
  ComputerDataNotifier() : super([]);

  void addComputerData(ComputerData data) {
    if (state.length >= 10) state.removeAt(0);
    state = [...state, data];
  }

  void clearComputerData() {
    state = [];
  }
}
