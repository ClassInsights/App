import 'package:flutter/material.dart';

class SensorData {
  final DateTime date;
  final double value;
  final String unit;
  final IconData? icon;

  SensorData({
    required this.date,
    required this.value,
    required this.unit,
    required this.icon,
  });
}
