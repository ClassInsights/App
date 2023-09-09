import 'dart:convert';

import 'package:classinsights/models/subject.dart';
import 'package:classinsights/providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;

final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>((ref) => SubjectNotifier(ref));

class SubjectNotifier extends StateNotifier<List<Subject>> {
  final StateNotifierProviderRef ref;
  SubjectNotifier(this.ref) : super([]);

  List<Subject> get subject => state;

  Subject? getSubjectById(int id) {
    if (state.isEmpty) return null;
    if (!state.any((subject) => subject.id == id)) return null;
    return state.firstWhere((subject) => subject.id == id);
  }

  Future<List<Subject>> fetchSubjects() async {
    final token = ref.read(authProvider).creds.accessToken;
    if (token.isEmpty) return [];
    if (state.isNotEmpty) return state;
    final client = http.Client();
    final response = await client.get(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/subjects"),
      headers: {
        "Authorization": "Bearer ${ref.read(authProvider).creds.accessToken}",
      },
    );
    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);

    final List<Subject> subjects = data.map<Subject>((subject) {
      return Subject(
        id: subject["subjectId"],
        name: subject["name"],
        longName: subject["longName"],
      );
    }).toList();

    if (subjects.isNotEmpty) state = subjects;
    return subjects;
  }
}
