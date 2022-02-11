import 'package:flutter/material.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  @override
  Widget build(StatelessWidget) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("data"),
        ),
        body: textLayoutWidget(),
      ),
    );
  }
}

Widget textLayoutWidget() {
  return Padding(
    padding: EdgeInsets.all(25.0),
    child: TextButton(
      style:ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 72, 187, 76)),
        foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 0, 0)),
      ),
      onPressed: (){},
      child: const Text("Start scan"))
  );
}
