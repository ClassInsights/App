import 'package:classinsights/models/localstore_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localstoreProvider = StateNotifierProvider<LocalstoreNotifier, List<LocalstoreItem>>((ref) => LocalstoreNotifier(ref));

class LocalstoreNotifier extends StateNotifier<List<LocalstoreItem>> {
  final StateNotifierProviderRef ref;
  LocalstoreNotifier(this.ref) : super([]);

  Future<LocalstoreItem?> item(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    return value != null ? LocalstoreItem(key, value) : null;
  }

  void setItem(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    state = [...state, LocalstoreItem(key, value)];
  }

  void removeItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    state = state.where((element) => element.key != key).toList();
  }

  void clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    state = [];
  }
}
