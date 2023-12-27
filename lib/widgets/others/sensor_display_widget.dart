import 'dart:convert';

import 'package:classinsights/helpers/custom_http_client.dart';
import 'package:classinsights/main.dart';
import 'package:classinsights/models/sensor_data.dart';
import 'package:classinsights/widgets/container/widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SensorDisplayWidget extends ConsumerStatefulWidget {
  final String? roomName;
  const SensorDisplayWidget(this.roomName, {super.key});

  @override
  ConsumerState<SensorDisplayWidget> createState() =>
      SensorDisplayWidgetState();
}

class SensorDisplayWidgetState extends ConsumerState<SensorDisplayWidget> {
  List<SensorData> _sensorData = [];
  bool _isLoading = true;

  Future<void> fetchSensorData() async {
    if (widget.roomName == null) return;
    final client = CustomHttpClient();
    // final response =
    //     await client.get("/rooms/sensor_${widget.roomName}/sensors");
    final response = await client.get("/rooms/sensor_og3-3/sensors");
    if (response.statusCode != 200) return;
    final data = jsonDecode(response.body);

    final List<SensorData> sensorData =
        data.map<SensorData>((singleSensorData) {
      String unit = "";
      IconData? icon;

      switch (singleSensorData["field"]) {
        case "CO2":
          unit = " ppm";
          icon = Icons.co2_rounded;
          break;
        case "temperature":
          unit = "°C";
          icon = Icons.thermostat_rounded;
          break;
        case "relative_humidity":
          unit = "%";
          icon = Icons.water_drop_rounded;
          break;
        default:
      }

      return SensorData(
        date: DateTime.parse(singleSensorData["date"]),
        value: singleSensorData["value"],
        unit: unit,
        icon: icon,
      );
    }).toList();

    setState(() => _sensorData = sensorData);
  }

  @override
  void initState() {
    fetchSensorData().then((_) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.roomName == null) return const SizedBox.shrink();
    return WidgetContainer(
      primary: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Raumdaten",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: App.defaultPadding),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          else if (_sensorData.isEmpty)
            Text(
              "Keine Daten für diesen Raum verfügbar",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          else
            ..._sensorData.map((sensorData) {
              if (sensorData.icon == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      sensorData.icon,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(width: App.defaultPadding),
                    Text(
                      "${sensorData.value.toString().replaceAll(".", ",")}${sensorData.unit}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
