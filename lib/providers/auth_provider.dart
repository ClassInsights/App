import 'dart:convert';

import 'package:classinsights/helpers/custom_http_client.dart';
import 'package:classinsights/models/auth_credentials.dart';
import 'package:classinsights/models/auth_data.dart';
import 'package:classinsights/models/user_role.dart';
import 'package:classinsights/providers/localstore_provider.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final authProvider =
    StateNotifierProvider<AuthNotifier, Auth>((ref) => AuthNotifier(ref));

class AuthNotifier extends StateNotifier<Auth> {
  final StateNotifierProviderRef ref;
  AuthNotifier(this.ref) : super(Auth.blank());

  Auth get auth => state;

  Future<AuthData?> getAuthData({required String accessToken}) async {
    final token = accessToken.isNotEmpty ? accessToken : auth.creds.accessToken;
    final tokenData = JWT.tryDecode(token);

    if (tokenData == null) return null;

    final payload = tokenData.payload;
    final classId = payload["class"];

    final userRole = Role.values.firstWhere((data) =>
        data.name.toLowerCase() == payload["role"].toString().toLowerCase());

    final classes = classId is String
        ? [int.parse(classId)]
        : classId is List<int>
            ? classId
            : [];

    return AuthData(
      name: payload["name"],
      id: payload["sub"],
      email: payload["email"],
      role: userRole,
      schoolClasses: classes as List<int>,
      expirationDate:
          DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000),
    );
  }

  void logout() async {
    ref.read(localstoreProvider.notifier).removeItem("ci_accessToken");
    ref.read(localstoreProvider.notifier).removeItem("ci_refreshToken");

    final client = await CustomHttpClient.create();
    await client.delete(
      "/token",
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
    var accessToken =
        (await ref.read(localstoreProvider.notifier).item("ci_accessToken"))
            ?.value;
    var refreshToken =
        (await ref.read(localstoreProvider.notifier).item("ci_refreshToken"))
            ?.value;

    if (accessToken == null || refreshToken == null) return false;

    final tokenData = JWT.tryDecode(accessToken);
    if (tokenData == null) return false;
    final expired =
        DateTime.fromMillisecondsSinceEpoch(tokenData.payload["exp"] * 1000)
            .isBefore(DateTime.now());
    if (expired && await _refreshToken(accessToken, refreshToken) == false)
      return false;

    if (expired) {
      accessToken =
          (await ref.read(localstoreProvider.notifier).item("ci_accessToken"))
              ?.value;
      refreshToken =
          (await ref.read(localstoreProvider.notifier).item("ci_refreshToken"))
              ?.value;
      if (accessToken == null || refreshToken == null) return false;
    }

    final authData = await getAuthData(accessToken: accessToken);
    if (authData == null) return false;

    state = Auth(
      creds: AuthCredentials(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
      data: authData,
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
    if (userId == null || accessToken == "" || refreshToken == "") {
      return false;
    }
    final client = await CustomHttpClient.create();
    final response = await client.post(
      "/token",
      body: {
        "userId": userId,
        "refreshToken": refreshToken,
      },
    );
    if (response.statusCode != 200) return false;

    final body = jsonDecode(response.body);
    ref
        .read(localstoreProvider.notifier)
        .setItem("ci_accessToken", body["access_token"]);
    ref
        .read(localstoreProvider.notifier)
        .setItem("ci_refreshToken", body["refresh_token"]);
    return true;
  }

  Future<bool> verifyLogin() async {
    if (state.creds.accessToken.isEmpty || state.creds.refreshToken.isEmpty)
      return false;
    final accessToken =
        (await ref.read(localstoreProvider.notifier).item("ci_accessToken"))
                ?.value ??
            "Unknown";
    final refreshToken =
        (await ref.read(localstoreProvider.notifier).item("ci_refreshToken"))
                ?.value ??
            "Unknown";

    final authData = await getAuthData(accessToken: accessToken);
    if (authData == null) return false;

    state = Auth(
      creds: AuthCredentials(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
      data: authData,
    );

    return true;
  }

  Future<bool> initialLogin(dynamic code) async {
    if (code is! String) return false;

    final client = await CustomHttpClient.create();
    final response = await client.get("/login/?code=$code");

    if (response.statusCode != 200) return false;

    final body = json.decode(response.body);
    final accessToken = body["access_token"];
    final refreshToken = body["refresh_token"];

    final localstore = ref.read(localstoreProvider.notifier);
    localstore.setItem("ci_accessToken", accessToken);
    localstore.setItem("ci_refreshToken", refreshToken);

    final authData = await getAuthData(accessToken: accessToken);
    if (authData == null) return false;

    state = Auth(
      creds: AuthCredentials(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
      data: authData,
    );
    return true;
  }
}
