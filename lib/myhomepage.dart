import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
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
      popupmodel(context!,imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
                child: Text('Capture Image with Camera'),
                onPressed: () {
                  _getFromCamera();

                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 16)))),
          ),
        ],
      ),
    );
  }

  void popupmodel(context,File) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(

            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15))
            ),
              height: MediaQuery.of(context).size.height * .40,
              child: Padding(
                padding: EdgeInsets.all(25.0),
                  child: Image.file(File),
              ),

          );
        });
  }
}
