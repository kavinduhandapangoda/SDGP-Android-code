import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? imageFile;

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
      popupModel(context, imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            child: const Text('Capture Image'),
            onPressed: () {
              _getFromCamera();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20))
            )
        ),
      ),
    );
  }

  void popupModel(context, file) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))
            ),
            height: MediaQuery.of(context).size.height * .95,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.file(file),
            ),
          );
        });
  }
}
