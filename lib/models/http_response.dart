import 'package:flutter/material.dart';

class Response {
  final int statusCode;
  final String body;

  Response({
    required this.statusCode,
    required this.body,
  }) {
    if (statusCode == -1) {
      debugPrint("Error while sending request: $body");
    }
  }
}
