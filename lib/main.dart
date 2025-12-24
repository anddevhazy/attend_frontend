import 'package:attend/core/config/environment.dart';
import 'package:attend/core/config/flavor_config.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.init(
    environment: Environment.dev,
    baseApiUrl: 'https://attend-api-staging.onrender.com',
  );

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Attend',
          debugShowCheckedModeBanner: false,
          routerConfig: Routes.router,
        );
      },
    );
  }
}
