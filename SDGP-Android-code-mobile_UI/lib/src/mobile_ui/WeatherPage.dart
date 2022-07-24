import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ui_kit_obkm/src/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
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
                      " Disease Database ",
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
                SizedBox(height: 37.h),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: 7,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return SizedBox(
                      height: 125.h,
                      // padding: EdgeInsets.only(left: 11.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                width: 125.h,
                                height: 125.h,
                                // margin: EdgeInsets.only(right: 14.w),
                                color: const Color(0xffD0D0D0),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 15.w,
                                      right: 2.w,
                                      top: 10.h,
                                      bottom: 10.h,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Black Beetle",
                                            style: GoogleFonts.workSans(
                                              textStyle: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.black,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Text(
                                          "Diseases Database is a cross-referenced index of human disease, "
                                              "medications, symptoms.",
                                          style: GoogleFonts.workSans(
                                            textStyle: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (c, i) {
                    return SizedBox(height: 24.h);
                  },
                ),
                SizedBox(height: 8.h),
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
