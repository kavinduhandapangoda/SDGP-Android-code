import 'package:sdgp_application_v1/quickScanPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coconut Disease Detection',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const QuickScanPage(),
    );
  }
}
