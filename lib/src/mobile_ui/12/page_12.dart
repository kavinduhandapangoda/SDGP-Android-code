import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_ui_kit_obkm/res/asset_images.dart';
import 'package:flutter_ui_kit_obkm/src/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_ui_kit_obkm/src/mobile_ui/5/page5.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/quickScanPage.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/main3.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/scanPage.dart';

import 'package:flutter_ui_kit_obkm/src/mobile_ui/WeatherPage.dart';

import 'package:flutter_ui_kit_obkm/src/mobile_ui/weatherScreen.dart';

import '../WeatherPage.dart';

class Page12 extends StatefulWidget {
  const Page12({Key? key}) : super(key: key);

  @override
  _Page12State createState() => _Page12State();
}

class _Page12State extends State<Page12> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Container(
          height: 900,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(23.w, 30.h, 23.w, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'AgroScan',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Divider(
                      height: 60.h,
                      color: const Color(0xFFD0D0D0),
                      thickness: 1),
                  SizedBox(height: 19.h),
                  Center(
                      child: Wrap(
                    spacing: 30.w,
                    runSpacing: 37.h,
                    children: [
                      _FullScan(),
                      _QuickScan(),
                      _Databse(),
                      WeatherPage(),
                      _exitButton(),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget WeatherPage() => Opacity(
        opacity: 1,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const weatherScreen()));
          },
          child: Column(
            children: [
              Container(
                width: 137.w,
                height: 160.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/weatherb.png"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ' Weather ',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _FullScan() => Opacity(
        opacity: 1,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ScanPage()));
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                height: 150.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/fullscan.png"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Full Scan',
                style: TextStyle(
                  color: Color.fromARGB(255, 249, 249, 249),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _QuickScan() => Opacity(
        opacity: 1,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const QuickScanPage()));
          },
          child: Column(
            children: [
              Container(
                width: 137.w,
                height: 160.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/quickscan.png"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ' Quick Scan ',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _Databse() => Opacity(
        opacity: 1,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Page5()));
          },
          child: Column(
            children: [
              Container(
                width: 137.w,
                height: 160.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/download__1.png"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ' Database ',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _exitButton() => Opacity(
        opacity: 1,
        child: InkWell(
          onTap: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: Column(
            children: [
              Container(
                width: 137.w,
                height: 160.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/exit.png"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ' Exit ',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
