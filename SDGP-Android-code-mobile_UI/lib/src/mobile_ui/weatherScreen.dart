import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ui_kit_obkm/src/navigation/navigation_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class weatherScreen extends StatefulWidget {
  const weatherScreen({Key? key}) : super(key: key);

  @override
  _weatherScreenState createState() => _weatherScreenState();
}

class _weatherScreenState extends State<weatherScreen> {
  int currentPage = 0;

  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  var location;
  var rain;
  var _latitude = "";
  var _longitude = "";

  Future _getLocation() async {
    Position position = await _determinePosition();
    _latitude = await position.latitude.toString();
    _longitude = await position.longitude.toString();
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

  Future _getWeather() async {
    await Future.delayed(const Duration(seconds: 1), () {});

    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${_latitude}&lon=${_longitude}&units=imperial&appid=0fe8f2e9003d6b4c89249a85fbd88f14"));
    var results = await jsonDecode(response.body);
    setState(() {
      this.location = results['name'];
      this.temp = results['main']["temp"];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
      print("current Temp: " + temp.toString());
      this.temp = (5 / 9) * (temp - 32);
      print("current Temp in C: " + temp.toStringAsFixed(2));
    });
  }

  @override
  void initState() {
    _getLocation();
    super.initState();
    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: 900,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/weather.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
              padding: EdgeInsets.only(left: 0.w, right: 0.w, bottom: 8.h),
              child: Column(children: [
                SizedBox(height: 37.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 24.r,
                        height: 24.r,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.only(top: 20, right: 120),
                  child: Text(
                    location != null ? location.toString() : "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 160.h),

                Padding(
                    padding: EdgeInsets.only(top: 20, right: 120),
                    child: Text(
                      temp != null
                          ? temp.toStringAsFixed(2) + "\u00B0"
                          : "Loading",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80.w,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20, right: 200),
                    child: Text(
                      temp != null ? currently.toString() : "Loading",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.w,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                //  Container(
                //  height: MediaQuery.of(context).size.height / 3,
                //         width: MediaQuery.of(context).size.width,
                //       color: Colors.green,
                //     child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //      children: [
                //      Padding(
                //      padding: EdgeInsets.only(bottom: 10.0),
                ////    child: Text(
                //  location != null
                //    ? "Currenlty in " + location.toString()
                //  : "",
                //                style: TextStyle(
                //                color: Colors.white,
                //              fontSize: 18.w,
                //            fontWeight: FontWeight.w600,
                //        ),
                //    ),
                //          ),
                //        Text(
                //        temp != null
                //          ? temp.toStringAsFixed(2) + "\u00B0"
                //        : "Loading",
                //  style: TextStyle(
                //          color: Colors.white,
                //        fontSize: 50.w,
                //      fontWeight: FontWeight.w600,
                //  ),
                //            ),
                //          Padding(
                //          padding: EdgeInsets.only(top: 10.0),
                //        child: Text(
                //        currently != null
                //          ? currently.toString() + "  "
                //        : "",
                //  style: TextStyle(
                //        color: Colors.white,
                //      fontSize: 20.w,
                //    fontWeight: FontWeight.w600,
                //),
                //              ),
                //          ),
                //      ],
                //       ),
                //   ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.white,
                  thickness: 5,
                ),
                SizedBox(height: 20),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Text(
                          "Wind ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          windspeed != null ? windspeed.toString() : "Loading",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "km/h",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Column(children: [
                        Text(
                          "Rain ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          windspeed != null ? rain.toString() : "Loading",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Column(
                        children: [
                          Text(
                            "Humidity ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.w,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            humidity != null ? humidity.toString() : "Loading",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.w,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.w,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ]),
              ])),
        ),
      ),
    ));
  }

  var kAnimationDuration = const Duration(milliseconds: 200);
  var kPrimaryColor = Colors.black;

  // String? swipeDirection;

  AnimatedContainer buildDot(bool isCurrent) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 8.r,
      width: 8.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrent ? const Color(0xff525252) : const Color(0xffC4C4C4),
      ),
    );
  }
}
