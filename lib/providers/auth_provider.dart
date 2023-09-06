import 'dart:convert';

import 'package:classinsights/models/auth_credentials.dart';
import 'package:classinsights/models/auth_data.dart';
import 'package:classinsights/models/user_role.dart';
import 'package:classinsights/providers/localstore_provider.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import "package:http/http.dart" as http;

class Auth {
  final AuthCredentials creds;
  final AuthData data;

  const Auth({
    required this.creds,
    required this.data,
  });

  static Auth blank() => Auth(
        creds: AuthCredentials.blank(),
        data: AuthData.blank(),
      );
}

final authProvider = StateNotifierProvider<AuthNotifier, Auth>((ref) => AuthNotifier(ref));

class AuthNotifier extends StateNotifier<Auth> {
  final StateNotifierProviderRef ref;
  AuthNotifier(this.ref) : super(Auth.blank());

  Auth get auth => state;

  AuthData? getAuthData({String accessToken = ""}) {
    final token = accessToken.isNotEmpty ? accessToken : auth.creds.accessToken;
    final tokenData = JWT.tryDecode(token);
    if (tokenData == null) return null;

    final payload = tokenData.payload;
    return AuthData(
      name: payload["name"],
      id: payload["sub"],
      email: payload["email"],
      role: Role.values.firstWhere((data) => data.name.toLowerCase() == payload["role"].toString().toLowerCase()),
      schoolClass: payload["class"],
      headTeacher: payload["head"],
      expirationDate: DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000),
    );
  }

  void logout() {
    ref.read(localstoreProvider.notifier).removeItem("accessToken");
    ref.read(localstoreProvider.notifier).removeItem("refreshToken");
    state = Auth.blank();
    debugPrint("Logged out!");
  }

  void reload() async {
    final accessToken = (await ref.read(localstoreProvider.notifier).item("accessToken"))?.value;
    final refreshToken = (await ref.read(localstoreProvider.notifier).item("refreshToken"))?.value;

    state = Auth(
      creds: AuthCredentials(
        accessToken: accessToken ?? "",
        refreshToken: refreshToken ?? "",
      ),
      data: getAuthData() ?? AuthData.blank(),
    );
  }

  Future<bool> _refreshToken() async {
    final accessToken = await ref.read(localstoreProvider.notifier).item("accessToken");
    final refreshToken = await ref.read(localstoreProvider.notifier).item("refreshToken");
    if (accessToken == null || refreshToken == null) return false;

    final client = http.Client();
    var data = json.encode({
      "userId": getAuthData(accessToken: accessToken.value)?.id ?? "Unknown",
      "refreshToken": refreshToken.value,
    });

    debugPrint("DATA: $data");

    final response = await client.post(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/user"),
      headers: {"Content-Type": "application/json"},
      body: data,
    );

    client.close();

    if (response.statusCode != 200) {
      debugPrint("Error: ${response.statusCode}");
      return false;
    }

    final body = jsonDecode(response.body);
    final newAccessToken = body["access_token"];
    final newRefreshToken = body["refresh_token"];

    ref.read(localstoreProvider.notifier).setItem("accessToken", newAccessToken);
    ref.read(localstoreProvider.notifier).setItem("refreshToken", newRefreshToken);

    reload();
    return true;
  }

  Future<bool> verifyLogin() async {
    final accessToken = await ref.read(localstoreProvider.notifier).item("accessToken");
    final refreshToken = await ref.read(localstoreProvider.notifier).item("refreshToken");

    if (accessToken == null || refreshToken == null) return false;

    final data = getAuthData(accessToken: accessToken.value);
    if (data == null) return false;

    final expirationDate = getAuthData(accessToken: accessToken.value)?.expirationDate;
    debugPrint("Expiration Date: ${expirationDate.toString()}");

    if (expirationDate?.isBefore(DateTime.now()) == true) {
      if (await _refreshToken()) {
        debugPrint("Token refreshed!");
        return true;
      }
      debugPrint("Token refresh failed!");
      return false;
    }

    debugPrint("Token was still valid!");

    final actualAccessToken = (await ref.read(localstoreProvider.notifier).item("accessToken"))?.value ?? "Unknown";
    final actualRefreshToken = (await ref.read(localstoreProvider.notifier).item("refreshToken"))?.value ?? "Unknown";

    state = Auth(
      creds: AuthCredentials(
        accessToken: actualAccessToken,
        refreshToken: actualRefreshToken,
      ),
      data: getAuthData(accessToken: actualAccessToken) ?? AuthData.blank(),
    );

    return true;
  }

  Future<bool> initialLogin() async {
    final loginUrl = dotenv.env["AUTH_URL"] ?? "";
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: loginUrl,
        callbackUrlScheme: "classinsights",
      );
      final code = Uri.parse(result).queryParameters["code"];

      if (code == null) return false;

      final client = http.Client();
      final uri = "${dotenv.env['API_URL'] ?? ""}/user/login/$code";
      final response = await client.get(Uri.parse(uri));
      client.close();
      if (response.statusCode != 200) {
        debugPrint("Error: ${response.statusCode}");
        return false;
      }
      final body = jsonDecode(response.body);
      final accessToken = body["access_token"];
      final refreshToken = body["refresh_token"];

      ref.read(localstoreProvider.notifier).setItem("accessToken", accessToken);
      ref.read(localstoreProvider.notifier).setItem("refreshToken", refreshToken);

      state = Auth(
        creds: AuthCredentials(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
        data: getAuthData(accessToken: accessToken) ?? AuthData.blank(),
      );
    } catch (e) {
      return false;
    }
    return true;
  }
}
