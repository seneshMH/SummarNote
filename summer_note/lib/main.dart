import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/scheduler.dart';
import 'core/app_export.dart';
import 'package:device_preview/device_preview.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: theme,
          title: 'summer_note',
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.introScreen,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
