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

  Future _getWeather() async{
    await Future.delayed(const Duration(seconds: 1), (){});

    http.Response response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${_latitude}&lon=${_longitude}&units=imperial&appid=0fe8f2e9003d6b4c89249a85fbd88f14"));
    var results = await jsonDecode(response.body);
    print("URL: "+"https://api.openweathermap.org/data/2.5/weather?lat=${_latitude}&lon=${_longitude}&units=imperial&appid=0fe8f2e9003d6b4c89249a85fbd88f14");
    setState(() {
      this.location = results['name'];
      this.temp = results['main']["temp"];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
      print("current Temp: "+temp.toString());
      this.temp = (5/9) * (temp - 32);
      print("current Temp in C: "+temp.toStringAsFixed(2));
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: EdgeInsets.only(left: 0.w, right: 0.w, bottom: 8.h),
            child: Column(
              children: [
                SizedBox(height: 37.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 34.r,
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
                      " Weather Report ",
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
                SizedBox(height: 15.h),
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.green,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Padding(padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          location != null ? "Currenlty in "+location.toString(): "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.w,
                            fontWeight: FontWeight.w600,
                          ),

                        ),
                      ),

                      Text(temp != null? temp.toStringAsFixed(2)+"\u00B0" : "Loading",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.w,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          currently != null ? currently.toString()+"  " : "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 20,left:30 ),
                              child: FaIcon(FontAwesomeIcons.thermometerHalf),
                            ),

                            Padding(padding: EdgeInsets.only(top: 20,left:55 ),
                                child: Text("Temperature ")
                            ),

                            Padding(padding: EdgeInsets.only(top: 20,left:80 ),
                                child: Text(temp != null? temp.toStringAsFixed(2)+"\u00B0" : "Loading",
                                  style: TextStyle(
                                      fontSize: 18.w
                                  ),)
                            ),
                          ],
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 35),
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 20,left:30 ),
                              child: FaIcon(FontAwesomeIcons.cloud),
                            ),

                            Padding(padding: EdgeInsets.only(top: 20,left:40 ),
                                child: Text("Weather ")
                            ),

                            Padding(padding: EdgeInsets.only(top: 20,left:105 ),
                                child: Text(description != null? description : "Loading",
                                  style: TextStyle(
                                      fontSize: 18.w
                                  ),)
                            ),
                          ],
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 35),
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 20,left:30 ),
                              child: FaIcon(FontAwesomeIcons.sun),
                            ),

                            Padding(padding: EdgeInsets.only(top: 20,left:47 ),
                                child: Text("Humidity ")
                            ),

                            Padding(padding: EdgeInsets.only(top: 20,left:100 ),
                                child: Text(humidity != null? humidity.toString() : "Loading",
                                  style: TextStyle(
                                      fontSize: 18.w
                                  ),)
                            ),
                          ],
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 35),
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 20,left:30 ),
                              child: FaIcon(FontAwesomeIcons.wind),
                            ),

                            Padding(padding: EdgeInsets.only(top: 20,left:50 ),
                                child: Text("Wind ")
                            ),

                            Padding(padding: EdgeInsets.only(top: 20,left:120 ),
                                child: Text(windspeed != null? windspeed.toString() : "Loading",
                                  style: TextStyle(
                                      fontSize: 18.w
                                  ),)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );
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

