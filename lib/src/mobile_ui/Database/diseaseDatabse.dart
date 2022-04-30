import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ui_kit_obkm/src/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class diseaseDatabse extends StatefulWidget {
  const diseaseDatabse({Key? key}) : super(key: key);

  @override
  _diseaseDatabseState createState() => _diseaseDatabseState();
}

class _diseaseDatabseState extends State<diseaseDatabse> {
  int currentPage = 0;
  var results_data;

  Future<dynamic> _getdata() async{
    http.Response response = await http.get(Uri.parse("https://agroscan.loopweb.lk/Diseasedata"));
    var results = await jsonDecode(response.body);
    return results;
  }

  @override
  void initState() {
    super.initState();
    _getdata();
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

            FutureBuilder<dynamic>(
                future: _getdata(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return   ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
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
                                    child: Image.network(snapshot.data[i]['image']),
                                    color: const Color(0xFF83EA5E),
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
                                                snapshot.data[i]['name'],
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
                                              snapshot.data[i]['solution'],
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                  fontSize: 13.sp,
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
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
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
