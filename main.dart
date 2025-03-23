import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(GadiWalaApp());
}

class GadiWalaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gadi Wala App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
