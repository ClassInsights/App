import 'dart:convert';

import 'package:classinsights/models/auth_credentials.dart';
import 'package:classinsights/models/auth_data.dart';
import 'package:classinsights/models/schoolclass.dart';
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

  Future<AuthData?> getAuthData({String accessToken = ""}) async {
    final token = accessToken.isNotEmpty ? accessToken : auth.creds.accessToken;
    final tokenData = JWT.tryDecode(token);

    if (tokenData == null) return null;

    final payload = tokenData.payload;
    final classId = payload["class"];
    final client = http.Client();
    final response = await client.get(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/classes/$classId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    client.close();

    if (response.statusCode != 200) return null;

    final body = jsonDecode(response.body);
    return AuthData(
      name: payload["name"],
      id: payload["sub"],
      email: payload["email"],
      role: Role.values.firstWhere((data) => data.name.toLowerCase() == payload["role"].toString().toLowerCase()),
      schoolClass: SchoolClass(id: int.tryParse(classId) ?? 0, name: body["name"], headTeacher: body["head"]),
      expirationDate: DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000),
    );
  }

  void logout() async {
    ref.read(localstoreProvider.notifier).removeItem("accessToken");
    ref.read(localstoreProvider.notifier).removeItem("refreshToken");

    final client = http.Client();
    await client.delete(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/token"),
      headers: {
        "Authorization": "Bearer ${auth.creds.accessToken}",
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "userId": auth.data.id,
          "refreshToken": auth.creds.refreshToken,
        },
      ),
    );

    reload();
  }

  Future<bool> reload() async {
    final accessToken = (await ref.read(localstoreProvider.notifier).item("accessToken"))?.value;
    final refreshToken = (await ref.read(localstoreProvider.notifier).item("refreshToken"))?.value;

    if (accessToken == null || refreshToken == null) {
      state = Auth.blank();
      return false;
    }

    final tokenData = JWT.tryDecode(accessToken);
    if (tokenData == null) {
      state = Auth.blank();
      return false;
    }

    if (DateTime.fromMillisecondsSinceEpoch(tokenData.payload["exp"] * 1000).isBefore(DateTime.now()) && await _refreshToken() == false) return false;

    state = Auth(
      creds: AuthCredentials(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
      data: await getAuthData(accessToken: accessToken) ?? AuthData.blank(),
    );
    return true;
  }

  String translateRole(Role role) {
    switch (role) {
      case Role.admin:
        return "Administrator";
      case Role.teacher:
        return "Lehrer";
      case Role.student:
        return "Schüler";
      default:
        return "Unbekannte Role";
    }
  }

  Future<bool> _refreshToken() async {
    final accessToken = await ref.read(localstoreProvider.notifier).item("accessToken");
    final refreshToken = await ref.read(localstoreProvider.notifier).item("refreshToken");
    if (accessToken == null || refreshToken == null) return false;

    final userId = JWT.tryDecode(accessToken.value)?.payload["sub"];
    if (userId == null) return false;

    final client = http.Client();
    final response = await client.post(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/token"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userId": userId,
        "refreshToken": refreshToken.value,
      }),
    );
    client.close();

    if (response.statusCode != 200) return false;

    final body = jsonDecode(response.body);
    final newAccessToken = body["access_token"];
    final newRefreshToken = body["refresh_token"];

    ref.read(localstoreProvider.notifier).setItem("accessToken", newAccessToken);
    ref.read(localstoreProvider.notifier).setItem("refreshToken", newRefreshToken);

    reload();
    return true;
  }

  Future<bool> verifyLogin() async {
    final accessToken = state.creds.accessToken;
    final refreshToken = state.creds.refreshToken;
    if (accessToken.isEmpty || refreshToken.isEmpty) return false;

    final actualAccessToken = (await ref.read(localstoreProvider.notifier).item("accessToken"))?.value ?? "Unknown";
    final actualRefreshToken = (await ref.read(localstoreProvider.notifier).item("refreshToken"))?.value ?? "Unknown";

    state = Auth(
      creds: AuthCredentials(
        accessToken: actualAccessToken,
        refreshToken: actualRefreshToken,
      ),
      data: (await getAuthData(accessToken: actualAccessToken)) ?? AuthData.blank(),
    );

    return true;
  }

  Future<bool> initialLogin() async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: dotenv.env["AUTH_URL"] ?? "",
        callbackUrlScheme: "classinsights",
      );

      final code = Uri.parse(result).queryParameters["code"];

      if (code == null) return false;

      final client = http.Client();
      final response = await client.get(Uri.parse("${dotenv.env['API_URL'] ?? ""}/login/$code"));
      client.close();

      if (response.statusCode != 200) return false;

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
        data: await getAuthData(accessToken: accessToken) ?? AuthData.blank(),
      );
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }
}
