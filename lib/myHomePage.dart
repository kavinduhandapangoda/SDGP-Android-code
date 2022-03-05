import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? imageFile;

  var _latitude = "";
  var _longitude = "";
  var _altitude = "";

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      _getLocation();
      imageFile = File(pickedFile!.path);
      popupModel(context, imageFile);
    });
  }

  Future<void> _getLocation() async {
    Position position = await _determinePosition();

    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      _altitude = position.altitude.toString();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            child: const Text('Capture Image'),
            onPressed: () {
              _getLocation();
              if (_latitude != "") {
                _getFromCamera();
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                textStyle:
                    MaterialStateProperty.all(const TextStyle(fontSize: 20)))),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            height: MediaQuery.of(context).size.height * .95,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Latitude:' + _latitude,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    'Longitude:' + _longitude,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    'Latitude:' + _altitude,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.file(
                      file,
                      height: 300.0,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
