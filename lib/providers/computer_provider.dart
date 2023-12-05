import 'dart:convert';

import 'package:classinsights/helpers/custom_http_client.dart';
import 'package:classinsights/models/computer.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final computerProvider = StateNotifierProvider<ComputerProvider, List<Computer>>((ref) => ComputerProvider(ref));

class ComputerProvider extends StateNotifier<List<Computer>> {
  final StateNotifierProviderRef ref;
  ComputerProvider(this.ref) : super([]);

  List<Computer> get computers => state;

  void clear() => state = [];

  Future<List<Computer>> fetchComputers(int roomId) async {
    final computersForRoom = state.where((computer) => computer.roomId == roomId).toList();
    if (computersForRoom.isNotEmpty) return computersForRoom;
    final token = ref.read(authProvider).creds.accessToken;
    if (token.isEmpty) return [];

    final client = await CustomHttpClient.create();
    final response = await client.get("/rooms/$roomId/computers");

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final List<Computer> newComputers = data.map<Computer>((computer) {
      return Computer(
        id: computer["computerId"],
        roomId: computer["roomId"],
        name: computer["name"],
        macAddress: computer["macAddress"]?.replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}:").substring(0, 17),
        ipAddress: computer["ipAddress"],
        lastUser: computer["lastUser"],
        lastSeen: DateTime.parse(computer["lastSeen"]),
        online: computer["online"],
      );
    }).toList();
    if (newComputers.isNotEmpty) state = [...state, ...newComputers];
    return newComputers;
  }

  Computer? getComputerById(int id) {
    if (state.isEmpty) return null;
    if (!state.any((room) => room.id == id)) return null;
    return state.firstWhere((room) => room.id == id);
  }

  Future<bool> shutdown(int computerId) async {
    final token = ref.read(authProvider).creds.accessToken;
    if (token.isEmpty) return false;

    final client = await CustomHttpClient.create();
    final response = await client.delete("/computers/$computerId");

    return response.statusCode == 200;
  }
}
