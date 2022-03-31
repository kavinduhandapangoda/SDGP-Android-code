import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

import 'main3.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isWorking = false;
  String result = '';
  CameraController? cameraController;
  CameraImage? cameraImage;
  String label = '';
  double confidence = 0;
  bool timerOn = false;
  final screenshotController = ScreenshotController();
  Uint8List? imageInUnit8List;

  setCameraController() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    initCamera();
  }

  initCamera() {
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageFromStream) => {
            if (!isWorking)
              {
                isWorking = true,
                cameraImage = imageFromStream,
                runModelOnStreamFrames(),
              }
          });
        });
      }
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setCameraController();
    loadModel();
    // loadImage();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();

    await Tflite.close();
    cameraController?.dispose();
  }

  runModelOnStreamFrames() async {
    if (cameraImage != null) {
      var recognition = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 0,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );
      result = '';

      for (var response in recognition!) {
        result += response['label'] + '   ' + (response['confidence'] as double).toStringAsFixed(2) + '\n';
        label = response['label'];
        confidence = response['confidence'] as double;
      }

      setState(() {
        result;
      });

      if (label != 'Fresh' && confidence > 0.80) {
        captureImage();
      }

      isWorking = false;
    }
  }

  Future<void> captureImage() async {

    if (timerOn == false) {

      setState(() {
        timerOn = true;
        isWorking = false;
      });

      // await cameraController?.stopImageStream();
      // await initCamera();
      // await cameraController?.lockCaptureOrientation();

      if (cameraController != null) {

        try {
          await takeScreenshot();
          // setState(() {
          //   capturedImage = takePicture();
          // });
        } catch (e) {
          print(e);
          print("Error");
        }
      }

      Timer(const Duration(seconds: 5), (){
        setState(() {
          timerOn = false;
        });
      });
    }
  }

  // Future loadImage() async {
  //   final appDir = await getApplicationDocumentsDirectory();
  //   File file = File('${appDir.path}/image.png');
  //
  //   if (file.existsSync()) {
  //     final imageInUnit8List = await file.readAsBytes();
  //
  //     setState(() {
  //       this.imageInUnit8List = imageInUnit8List;
  //     });
  //   }
  // }

  Future<void> takeScreenshot() async {
    Uint8List? imageInUnit8List = await screenshotController.capture();

    if (imageInUnit8List != null) {
      final appDir = await getApplicationDocumentsDirectory();
      File file = File('${appDir.path}/image.png');
      file.writeAsBytes(imageInUnit8List);
      print('Captured');
    } else {
      print('Not Captured');
    }
  }

  // Future<XFile?> takePicture() async{
  //   final CameraController? controller = cameraController;
  //
  //   if (controller!.value.isTakingPicture) {
  //     // A capture is already pending, do nothing.
  //     return null;
  //   }
  //
  //   try {
  //     XFile file = await controller.takePicture();
  //     print("Captured Image");
  //     return file;
  //   } on CameraException catch (e) {
  //     print('Error occured while taking picture: $e');
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coconut Disease Detection'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Center(
              child: TextButton(
                onPressed: () {
                  setCameraController();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  height: 405,
                  width: 390,
                  child: cameraImage == null
                      ? const SizedBox(
                    height: 270,
                    width: 360,
                    child: Icon(
                      Icons.photo_camera_front,
                      color: Colors.pink,
                      size: 60.0,
                    ),
                  )
                      : Screenshot(
                          controller: screenshotController,
                          child: AspectRatio(
                            aspectRatio: cameraController!.value.aspectRatio,
                            child: CameraPreview(cameraController!),
                          ),
                      ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(
                      backgroundColor: Colors.black,
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
