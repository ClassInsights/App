import 'dart:convert';

import 'package:classinsights/models/computer.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;

final computerProvider = StateNotifierProvider<ComputerProvider, List<Computer>>((ref) => ComputerProvider(ref));

class ComputerProvider extends StateNotifier<List<Computer>> {
  final StateNotifierProviderRef ref;
  ComputerProvider(this.ref) : super([]);

  List<Computer> get computers => state;

  Future<List<Computer>> fetchComputers(int roomId) async {
    final token = ref.read(authProvider).creds.accessToken;
    if (token.isEmpty) return [];
    final client = http.Client();
    final response = await client.get(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/rooms/$roomId/computers"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    client.close();
    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);

    final List<Computer> computers = data.map<Computer>((computer) {
      return Computer(
        id: computer["computerId"],
        roomId: computer["roomId"],
        name: computer["name"],
        macAddress: computer["macAddress"],
        ipAddress: computer["ipAddress"],
        lastUser: computer["lastUser"],
        lastSeen: DateTime.parse(computer["lastSeen"]),
      );
    }).toList();

    if (computers.isNotEmpty) state = computers;
    return computers;
  }

  Computer? getComputerById(int id) {
    if (state.isEmpty) return null;
    if (!state.any((room) => room.id == id)) return null;
    return state.firstWhere((room) => room.id == id);
  }

  Future<bool> shutdown(int computerId) async {
    final token = ref.read(authProvider).creds.accessToken;
    if (token.isEmpty) return false;
    final client = http.Client();
    final response = await client.delete(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/computers/$computerId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    client.close();
    return response.statusCode == 200;
  }
}
