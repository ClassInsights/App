import 'dart:convert';

import 'package:classinsights/models/room.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/computer_provider.dart';
import 'package:classinsights/providers/ratelimit_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;

final roomProvider = StateNotifierProvider<RoomNotifier, List<Room>>((ref) => RoomNotifier(ref));

class RoomNotifier extends StateNotifier<List<Room>> {
  final StateNotifierProviderRef ref;
  RoomNotifier(this.ref) : super([]);

  List<Room> get rooms => state;

  Future<void> refreshRooms() async {
    final ratelimit = ref.read(ratelimitProvider.notifier);
    if (ratelimit.isRateLimited("rooms")) return;
    ratelimit.addRateLimit("rooms");
    ref.read(computerProvider.notifier).clear();
    state = await fetchRooms(skipStateCheck: true);
  }

  Future<List<Room>> fetchRooms({bool skipStateCheck = false}) async {
    final token = ref.read(authProvider).creds.accessToken;
    if (token.isEmpty) return [];
    if (!skipStateCheck && state.isNotEmpty) return state;
    final client = http.Client();
    final response = await client.get(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/rooms"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final List<Room> rooms = data.map<Room>((room) {
      return Room(
        id: room["roomId"],
        name: room["longName"].toString().length >= 30 ? room["name"] : room["longName"],
        deviceCount: room["deviceCount"],
      );
    }).toList();

    if (rooms.isNotEmpty) state = rooms;
    return rooms;
  }

  Room? getRoomById(int id) {
    if (state.isEmpty) return null;
    if (!state.any((room) => room.id == id)) return null;
    return state.firstWhere((room) => room.id == id);
  }
}
