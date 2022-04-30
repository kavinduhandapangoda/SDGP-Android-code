import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/inc/main3.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/routes/routes.dart';
import 'package:get_it/get_it.dart';
import 'generated/l10n.dart';
import 'src/di/service_locator.dart';
import 'src/navigation/navigation_service.dart';
import 'package:flutter_ui_kit_obkm/src/mobile_ui/homePage/homePage.dart';

void main() async {
  await ServiceLocator().setUp();
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: () => MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: "Agroscan APP",
        themeMode: ThemeMode.light,
        navigatorKey: GetIt.I.get<NavigationService>().navigatorKey,
        initialRoute: MobileRoutes.root,
        home: Page12(),
      ),
    );
  }
}
