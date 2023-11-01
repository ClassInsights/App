import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Response {
  final int statusCode;
  final String body;

  Response({
    required this.statusCode,
    required this.body,
  });
}

class CustomHttpClient {
  late String _baseUrl;
  late HttpClient _httpClient;
  late String? _accessToken;
  final bool _withCredentials;
  bool isClosed = false;

  CustomHttpClient({bool withCredentials = true}) : _withCredentials = withCredentials {
    _httpClient = HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => host == dotenv.env['CA_HOST']);
    final baseUrl = dotenv.env['API_URL'];
    if (baseUrl == null) exit(1);
    _baseUrl = baseUrl;
    initializeToken().then((token) => _accessToken = token);
  }

  Future<String?> initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("ci_accessToken");
  }

  void _closeClient() {
    if (isClosed) return;
    _httpClient.close(force: true);
    isClosed = true;
  }

  Future<Response> get(String path, {Map<String, String>? headers, bool keepAlive = false}) async {
    if (isClosed) return Response(statusCode: -1, body: "Client Already Closed");
    final uri = Uri.parse("$_baseUrl$path");
    final request = await _httpClient.getUrl(uri);
    if (_withCredentials && _accessToken == null) return Response(statusCode: -1, body: "No Access Token");
    if (_withCredentials) request.headers.add("Authorization", "Bearer $_accessToken");
    if (headers != null) headers.forEach((key, value) => request.headers.add(key, value));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (!keepAlive) _closeClient();
    return Response(
      statusCode: response.statusCode,
      body: body,
    );
  }

  Future<Response> post(String path, {Map<String, String>? headers, dynamic body, bool keepAlive = false}) async {
    if (isClosed) return Response(statusCode: -1, body: "Client Already Closed");
    final uri = Uri.parse("$_baseUrl$path");
    final request = await _httpClient.postUrl(uri);
    if (_withCredentials && _accessToken == null) return Response(statusCode: -1, body: "No Access Token");
    if (_withCredentials) request.headers.add("Authorization", "Bearer $_accessToken");
    if (body != null) request.headers.add("Content-Type", "application/json");
    if (headers != null) headers.forEach((key, value) => request.headers.add(key, value));
    if (body != null) request.write(jsonEncode(body));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    if (!keepAlive) _closeClient();
    return Response(
      statusCode: response.statusCode,
      body: responseBody,
    );
  }

  Future<Response> delete(String path, {Map<String, String>? headers, dynamic body, bool keepAlive = false}) async {
    if (isClosed) return Response(statusCode: -1, body: "Client Already Closed");
    final request = await _httpClient.deleteUrl(Uri.parse("$_baseUrl$path"));
    if (_withCredentials && _accessToken == null) return Response(statusCode: -1, body: "No Access Token");
    if (_withCredentials) request.headers.add("Authorization", "Bearer $_accessToken");
    if (body != null) request.headers.add("Content-Type", "application/json");
    if (headers != null) headers.forEach((key, value) => request.headers.add(key, value));
    if (body != null) request.write(jsonEncode(body));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    if (!keepAlive) _closeClient();
    return Response(
      statusCode: response.statusCode,
      body: responseBody,
    );
  }
}
