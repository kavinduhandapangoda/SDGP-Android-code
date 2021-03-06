import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;

import '../../navigation/navigation_service.dart';

class QuickScanPage extends StatefulWidget {
  const QuickScanPage({Key? key}) : super(key: key);

  @override
  _QuickScanPageState createState() => _QuickScanPageState();
}

class _QuickScanPageState extends State<QuickScanPage> {
  File? imageFile;
  String result = '';
  ImagePicker? imagePicker;

  String _solution = "";

  final String _beetle = """
      Mechanical Solution:
  
  Beetle can be removed using a
  pointed metal hook.
  
      Cultural Solution:
  
  Decaying coconut logs and
  stumps should be removed and
  burnt. Breeding media such as
  manure heaps and coir dust
  heaps should be disposed or
  earthed up with the soil.
  
      Chemical Solution:
  
  Place naphthalene balls into
  each of the innermost leaf
  axis.""";

  final String _mite = """
  - If reported only in a few
  palms, cut and burn all the
  nuts in the infested palms.
  
  - For infestations in boundary
  areas or heavily infested
  palms, apply 30% used engine
  oil on nuts of infested palms.
  Apply this mixture at 2 monthly
  intervals until the damage is
  reduced.
  
  - Apply palm / vegetable oil
  and Sulphur mixture. This
  mixture can be sprayed from
  ground level using a modified
  knapsack sprayer of a power
  sprayer""";

  final String _budRot = """
  - For infected young palms in
  an advanced stage, the crown
  should be cut and burnt to
  destroy the fungus.
  
  - If detected early, the bud
  region should be thoroughly
  wetted with Bordeaux mixture
  or 1% Copper fungicide
  solution.
  
  - For older bearing palms,
  wet the bud region with the
  recommended chemical to kill
  the fungus.""";

  final String _fresh = """
    No Diseases Detected...""";

  var _latitude = "";
  var _longitude = "";
  var _altitude = "";

  void _getFromCamera() async { // to capture image
    XFile? pickedFile = await imagePicker!.pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() async {
      // await _getLocation();
      imageFile = File(pickedFile!.path);
      await imageClassification(imageFile!);

      if (result.contains("Beetle")) {
        _solution = _beetle;
      } else if (result.contains("Coconut Mite")) {
        _solution = _mite;
      } else if (result.contains("Bud Rot")) {
        _solution = _budRot;
      } else if (result.contains("Fresh")) {
        _solution = _fresh;
      }

      popupModel(context, imageFile);
    });
  }

  // Reference: https://pub.dev/packages/tflite/example
  loadDataModelFiles() async { // loads the TensorFlow model
    String? output = await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
    print(output);
  }

  // Reference: https://pub.dev/packages/tflite/example
  Future imageClassification(File image) async { // classifies the captured image using the TensorFlow model
    var disease = "";
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
    );
    print(recognitions!.length.toString());
    setState(() {
      result = '';
    });
    recognitions.forEach((element) {
      setState(() {
        print(element.toString());
        result += element['label'] + ': ' + (element['confidence'] as double).toStringAsFixed(2) + '\n';
        disease = element['label'];
      });
    });
    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
    //print("la "+ _latitude+" lo "+ _longitude+" di "+disease);
    var locationString = _latitude+","+_longitude;
    print(locationString);
    addDataRecord(locationString,disease);
  }

  // Uint8List imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
  //   var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  //   var buffer = Float32List.view(convertedBytes.buffer);
  //   int pixelIndex = 0;
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) {
  //       var pixel = image.getPixel(j, i);
  //       buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
  //       buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
  //       buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
  //     }
  //   }
  //   return convertedBytes.buffer.asUint8List();
  // }

  void addDataRecord(String location, String disease) async {
    var url = Uri.parse('https://agroscan.loopweb.lk/reportLog/${location}/${disease}');
    var response = await http.get(url, headers: {});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    loadDataModelFiles();
    _getLocation();
  }

  // Reference: https://www.youtube.com/watch?v=bpKxAPm1Cig&t=386s
  void _getLocation() async { // gets latitude, longitude and altitude from the retrieved location information
    Position position = await _determinePosition();
    _latitude = position.latitude.toString();
    _longitude = position.longitude.toString();
    _altitude = position.altitude.toString();
  }

  // Reference: https://pub.dev/packages/geolocator
  Future<Position> _determinePosition() async { // retrieves current location information
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 8.h),
            child: Column(
              children: [
                SizedBox(height: 37.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: IconButton(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          GetIt.I.get<NavigationService>().back();
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      " Open Camera ",
                      style: GoogleFonts.workSans(
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 24.r,
                        height: 24.r,

                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.35),
                Center(
                  child: ElevatedButton(
                      child: const Text(' Open Camera '),
                      onPressed: () {
                        _getFromCamera();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                          textStyle:
                          MaterialStateProperty.all(const TextStyle(fontSize: 20)))),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void popupModel(context, file) { // displays the condition of the captured image of the tree
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
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Result\n',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 30.0,
                          ),
                        ),
                        Text(
                          result + '\n',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.file(
                            file,
                            height: 150.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _solution,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                )
            ),
          );
        });
  }
}
