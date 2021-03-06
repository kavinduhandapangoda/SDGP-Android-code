import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_ui_kit_obkm/res/asset_images.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/Database/diseaseDatabse.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/quickScan/quickScanPage.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/fullScan/scanPage.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/weatherPage/weatherScreen.dart';

class Page12 extends StatefulWidget {
  const Page12({Key? key}) : super(key: key);

  @override
  _Page12State createState() => _Page12State();
}

class _Page12State extends State<Page12> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(23.w, 30.h, 23.w, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child:Text(
                    'AgroScan',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5DA50B),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                Divider(
                    height: 60.h, color: const Color(0xFFD0D0D0), thickness: 1),
                SizedBox(height: 19.h),
                Center(
                  child:Wrap(
                    spacing: 30.w,
                    runSpacing: 37.h,

                    children: [
                      _FullScan(),
                      _QuickScan(),
                      _Databse(),
                      WeatherPage(),
                      _exitButton(),

                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget WeatherPage() =>
      Opacity(
        opacity: 1,
        child: InkWell(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const weatherScreen()));
          },
          child: Container(
            width: 137.w,
            height: 160.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
            decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(.25),
                  )
                ]),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                ),
                SvgPicture.asset(Assets.PG12_weather),
                const Expanded(child: SizedBox()),
                Text(
                  ' Weather ',
                  style: TextStyle(
                    color: const Color(0xFF208216),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _FullScan() =>
      Opacity(
        opacity: 1,
        child: InkWell(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ScanPage()));
          },
          child: Container(
            width:MediaQuery.of(context).size.width*0.78,
            height: 160.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
            decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(.25),
                  )
                ]),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                ),
                SvgPicture.asset(Assets.PG12_scan),
                const Expanded(child: SizedBox()),
                Text(
                  'Full Scan',
                  style: TextStyle(
                    color: const Color(0xFF208216),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _QuickScan() =>
      Opacity(
        opacity: 1,
        child: InkWell(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const QuickScanPage()));
          },
          child: Container(
            width: 137.w,
            height: 160.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
            decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(.25),
                  )
                ]),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                ),
                SvgPicture.asset(Assets.PG12_quickcan),
                const Expanded(child: SizedBox()),
                Text(
                  'Quick Scan',
                  style: TextStyle(
                    color: const Color(0xFF208216),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _Databse() =>
      Opacity(
        opacity: 1,
        child: InkWell(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const diseaseDatabse()));
          },
          child: Container(
            width: 137.w,
            height: 160.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
            decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(.25),
                  )
                ]),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                ),
                SvgPicture.asset(Assets.PG12_database),
                const Expanded(child: SizedBox()),
                Text(
                  'Disease Data',
                  style: TextStyle(
                    color: const Color(0xFF208216),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _exitButton() =>
      Opacity(
        opacity: 1,
        child: InkWell(
          onTap: (){
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: Container(
            width: 137.w,
            height: 160.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 33.h),
            decoration: BoxDecoration(
                color: const Color(0xFFC41F1F),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(.25),
                  )
                ]),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                ),
                SvgPicture.asset(Assets.PG12_close),
                const Expanded(child: SizedBox()),
                Text(
                  'Exit',
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
