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
    ref.read(localstoreProvider.notifier).removeItem("ci_accessToken");
    ref.read(localstoreProvider.notifier).removeItem("ci_refreshToken");

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
    var accessToken = (await ref.read(localstoreProvider.notifier).item("ci_accessToken"))?.value;
    var refreshToken = (await ref.read(localstoreProvider.notifier).item("ci_refreshToken"))?.value;

    if (accessToken == null || refreshToken == null) return false;
    final tokenData = JWT.tryDecode(accessToken);
    if (tokenData == null) return false;
    final expired = DateTime.fromMillisecondsSinceEpoch(tokenData.payload["exp"] * 1000).isBefore(DateTime.now());
    if (expired && await _refreshToken(accessToken, refreshToken) == false) return false;

    if (expired) {
      accessToken = (await ref.read(localstoreProvider.notifier).item("ci_accessToken"))?.value;
      refreshToken = (await ref.read(localstoreProvider.notifier).item("ci_refreshToken"))?.value;
      if (accessToken == null || refreshToken == null) return false;
    }

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

  Future<bool> _refreshToken(String accessToken, String refreshToken) async {
    final userId = JWT.tryDecode(accessToken)?.payload["sub"];
    if (userId == null) return false;

    final client = http.Client();
    final response = await client.post(
      Uri.parse("${dotenv.env['API_URL'] ?? ""}/token"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userId": userId,
        "refreshToken": refreshToken,
      }),
    );
    client.close();

    if (response.statusCode != 200) return false;

    final body = jsonDecode(response.body);
    ref.read(localstoreProvider.notifier).setItem("ci_accessToken", body["access_token"]);
    ref.read(localstoreProvider.notifier).setItem("ci_refreshToken", body["refresh_token"]);
    return true;
  }

  Future<bool> verifyLogin() async {
    if (state.creds.accessToken.isEmpty || state.creds.refreshToken.isEmpty) return false;
    final actualAccessToken = (await ref.read(localstoreProvider.notifier).item("ci_accessToken"))?.value ?? "Unknown";
    final actualRefreshToken = (await ref.read(localstoreProvider.notifier).item("ci_refreshToken"))?.value ?? "Unknown";

    final authData = await getAuthData(accessToken: actualAccessToken);
    if (authData == null) return false;

    state = Auth(
      creds: AuthCredentials(
        accessToken: actualAccessToken,
        refreshToken: actualRefreshToken,
      ),
      data: authData,
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

      ref.read(localstoreProvider.notifier).setItem("ci_accessToken", accessToken);
      ref.read(localstoreProvider.notifier).setItem("ci_refreshToken", refreshToken);

      final authData = await getAuthData(accessToken: accessToken);
      if (authData == null) return false;

      state = Auth(
        creds: AuthCredentials(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
        data: authData,
      );
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }
}
