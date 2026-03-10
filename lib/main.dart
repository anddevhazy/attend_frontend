import 'package:attend/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:attend/features/lecturer/presentation/bloc/lecturer_cubit.dart';
import 'package:attend/global/core/config/environment.dart';
import 'package:attend/global/core/config/flavor_config.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:attend/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.init(
    environment: Environment.dev,
    baseApiUrl: 'https://attend-staging-api.up.railway.app',
  );

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<LecturerCubit>()),
      ],
      child: ScreenUtilInit(
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
      ),
    );
  }
}
