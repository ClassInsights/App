import 'package:flutter_riverpod/flutter_riverpod.dart';

final ratelimitProvider = StateNotifierProvider<RateLimitNotifier, Map<String, DateTime>>((_) => RateLimitNotifier());

class RateLimitNotifier extends StateNotifier<Map<String, DateTime>> {
  RateLimitNotifier() : super({});

  Map<String, DateTime> get ratelimits => state;

  bool isRateLimited(String key) => ratelimits.containsKey(key);

  void addRateLimit(String key) async {
    ratelimits[key] = DateTime.now();
    await Future.delayed(const Duration(seconds: 10));
    ratelimits.remove(key);
  }
}
