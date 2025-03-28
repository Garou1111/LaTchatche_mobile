import 'package:flutter/material.dart';
import 'package:projet_flutter_411/tchatche.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Tchatche',
      initialRoute: '/',
      home: Tchatche(),
    );
  }
}
