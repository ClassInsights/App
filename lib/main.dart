import 'package:flutter/material.dart';
import './screens/tabs.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 32, 249, 210),
          background: Color.fromARGB(255, 32, 32, 32),
          surface: Color.fromARGB(255, 32, 32, 32),
        ),
      ),
      home: const TabsScreen(),
    );
  }
}
