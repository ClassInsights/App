import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final versionProvider = StateNotifierProvider<VersionNotifier, String>((_) => VersionNotifier());

class VersionNotifier extends StateNotifier<String> {
  VersionNotifier() : super("");

  String get version => state;

  Future<void> fetchVersion() async {
    var info = await PackageInfo.fromPlatform();
    state = info.version;
  }
}
