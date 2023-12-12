import 'dart:convert';

import 'package:classinsights/helpers/custom_http_client.dart';
import 'package:classinsights/models/schoolclass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final classesProvider = StateNotifierProvider<ClassNotifier, List<SchoolClass>>(
  (ref) => ClassNotifier(ref),
);

class ClassNotifier extends StateNotifier<List<SchoolClass>> {
  final StateNotifierProviderRef ref;
  ClassNotifier(this.ref) : super([]);

  SchoolClass? findClassById(int classId) {
    if (state.isEmpty) return null;
    if (!state.any((schoolClass) => schoolClass.id == classId)) return null;
    return state.firstWhere((schoolClass) => schoolClass.id == classId);
  }

  Future<void> fetchClasses() async {
    final client = await CustomHttpClient.create();
    final response = await client.get("/classes");

    if (response.statusCode != 200) return;

    final data = jsonDecode(response.body);

    final classes = data.map<SchoolClass>((classData) {
      return SchoolClass(
        id: classData["classId"],
        name: classData["name"],
        headTeacher: classData["head"],
      );
    }).toList();

    state = classes;
  }

  List<SchoolClass> get classData => state;
}
