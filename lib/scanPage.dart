import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;
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
        result += response['label'] +
            '   ' +
            (response['confidence'] as double).toStringAsFixed(2) +
            '\n';
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
          await convertImageToPng(cameraImage!);
          // setState(() {
          //   capturedImage = takePicture();
          // });
        } catch (e) {
          print(e);
          print("Error");
        }
      }

      Timer(const Duration(seconds: 5), () {
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
      child: Screenshot(
        controller: screenshotController,
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
                        : AspectRatio(
                            aspectRatio: cameraController!.value.aspectRatio,
                            child: CameraPreview(cameraController!),
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
      ),
    );
  }

  Future<Uint8List?> convertImageToPng(CameraImage image) async {
    Uint8List? bytes;
    try {
      imglib.Image img;
      if (image.format.group == ImageFormatGroup.yuv420) {
        bytes = (await convertYUV420toImageColor(image)) as Uint8List?;
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        img = _convertBGRA8888(image);
        imglib.PngEncoder pngEncoder = new imglib.PngEncoder();
        bytes = pngEncoder.encodeImage(img) as Uint8List?;
      }
      return bytes;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  imglib.Image _convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
  }

  Future<List<int>?> convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int? uvPixelStride = image.planes[1].bytesPerPixel;
      print("uvRowStride: " + uvRowStride.toString());
      print("uvPixelStride: " + uvPixelStride.toString());
      var img = imglib.Image(width, height); // Create Image buffer
      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final int uvIndex =
              uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = y * width + x;
          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
        }
      }
      imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
      List<int> png = pngEncoder.encodeImage(img);
      final originalImage = imglib.decodeImage(png);
      final height1 = originalImage?.height;
      final width1 = originalImage?.width;
      imglib.Image fixedImage = imglib.copyRotate(originalImage!, 90);

      //final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.jpg");
      //print(path);
      //File(path).writeAsBytesSync(imglib.encodeJpg(fixedImage));
      var temp = fixedImage;
      return imglib.encodeJpg(fixedImage);
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

}
