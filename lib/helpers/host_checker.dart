import 'dart:io';

Future<bool> checkHost(String? host, {int port = 443}) async {
  if (host == null) return false;
  try {
    final socket = await Socket.connect(host, port, timeout: const Duration(seconds: 5));
    await socket.close();
    return true;
  } catch (e) {
    return false;
  }
}
