import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_ui_kit_obkm/res/asset_images.dart';
import 'package:flutter_ui_kit_obkm/src/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';

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
                      _livingRoomItem(name: 'Full Scan', iconPath: Assets.PG12_LIGHT),

                      _livingRoomItem(name: 'Quick Scan', iconPath: Assets.PG12_SOFA),

                      _livingRoomItem(name: 'Diseases', iconPath: Assets.PG12_FRIDGE),

                      _livingRoomItem(name: 'Weather',iconPath: Assets.PG12_FAN),

                      _livingRoomItem(name: 'Fridge', iconPath: Assets.PG12_FRIDGE),

                      _livingRoomItem(name: 'Exit',iconPath: Assets.PG12_FAN),

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

  Widget _livingRoomItem(
          {required String name,
          required String iconPath,
          bool available = true,
          bool warning = false}) =>
      Opacity(
        opacity: available ? 1 : 0.2,
        child: Container(
          width: 137.w,
          height: 160.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
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
              SvgPicture.asset(iconPath),
              const Expanded(child: SizedBox()),
              Text(
                name,
                style: TextStyle(
                  color: const Color(0xFF208216),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _titleWidget(String title) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          GestureDetector(
              onTap: () {
                GetIt.I.get<NavigationService>().back();
              },
              child: const Icon(Icons.add_circle, color: Colors.black)),
        ],
      );
}
