//IM/2021/030
import 'package:cal_new/calculator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}
