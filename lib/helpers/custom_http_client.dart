import 'dart:convert';
import 'dart:io';
import 'package:classinsights/models/http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpClient {
  late HttpClient _client;
  late String? accessToken;
  late String? _baseUrl;
  late bool _keepAlive;
  var alreadyClosed = false;

  CustomHttpClient({String? baseUrl}) {
    final ctx = SecurityContext.defaultContext;
    _baseUrl = baseUrl ?? dotenv.env["API_URL"];
    rootBundle.loadString("assets/certificates/projekt-DC01PROJEKT-CA.pem").then((content) {
      ctx.setTrustedCertificatesBytes(content.codeUnits);
      ctx.allowLegacyUnsafeRenegotiation = true;
      _client = HttpClient(context: ctx);
    });
    SharedPreferences.getInstance().then((prefs) {
      accessToken = prefs.getString("access_token");
    });
  }

  CustomHttpClient._create({required String cert, required String token, required bool keepAlive, String? baseUrl}) {
    _baseUrl = baseUrl ?? dotenv.env["API_URL"];
    _keepAlive = keepAlive;
    final ctx = SecurityContext.defaultContext;
    ctx.setTrustedCertificatesBytes(cert.codeUnits);
    ctx.allowLegacyUnsafeRenegotiation = true;
    accessToken = token;
    _client = HttpClient(context: ctx);
  }

  static Future<CustomHttpClient> create({String? baseUrl, bool keepAlive = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("ci_accessToken");
    final certPath = dotenv.env['ROOT_CERT'];
    if (certPath == null) throw Exception("No root certificate path specified in .env file!");
    final content = await rootBundle.loadString(certPath);
    final client = CustomHttpClient._create(
      cert: content,
      token: accessToken ?? "",
      keepAlive: keepAlive,
      baseUrl: baseUrl,
    );
    return client;
  }

  void _closeClient() {
    _client.close();
    alreadyClosed = true;
  }

  Future<Response> get(String path, {bool withCredentials = true}) async {
    final uri = "$_baseUrl$path";
    debugPrint("GET $uri");
    try {
      if (alreadyClosed) return Response(statusCode: -1, body: "Client already closed!");
      final request = await _client.getUrl(Uri.parse(uri));
      if (withCredentials) request.headers.add("Authorization", "Bearer $accessToken");
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (!_keepAlive) _closeClient();
      return Response(
        statusCode: response.statusCode,
        body: body,
      );
    } catch (e) {
      debugPrint(e.toString());
      return Response(statusCode: -1, body: "Error while sending GET request: $uri");
    }
  }

  Future<Response> post(String path, {bool withCredentials = true, dynamic body}) async {
    final uri = "$_baseUrl$path";
    debugPrint("POST $uri");
    try {
      if (alreadyClosed) return Response(statusCode: -1, body: "Client already closed!");
      final request = await _client.postUrl(Uri.parse(uri));
      if (withCredentials) request.headers.add("Authorization", "Bearer $accessToken");
      if (body != null) {
        request.headers.add("Content-Type", "application/json");
        request.write(json.encode(body));
      }
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      if (!_keepAlive) _closeClient();
      return Response(
        statusCode: response.statusCode,
        body: responseBody,
      );
    } catch (e) {
      debugPrint(e.toString());
      return Response(statusCode: -1, body: "Error while sending POST request: $uri");
    }
  }

  Future<Response> delete(String path, {bool withCredentials = true, dynamic body}) async {
    final uri = "$_baseUrl$path";
    debugPrint("DELETE $_baseUrl$path");
    try {
      if (alreadyClosed) return Response(statusCode: -1, body: "Client already closed!");
      final request = await _client.postUrl(Uri.parse("$_baseUrl$path"));
      if (withCredentials) request.headers.add("Authorization", "Bearer $accessToken");
      if (body != null) {
        request.headers.add("Content-Type", "application/json");
        request.write(json.encode(body));
      }
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      if (!_keepAlive) _closeClient();
      return Response(
        statusCode: response.statusCode,
        body: responseBody,
      );
    } catch (e) {
      debugPrint(e.toString());
      return Response(statusCode: -1, body: "Error while sending DELETE request: $uri");
    }
  }
}