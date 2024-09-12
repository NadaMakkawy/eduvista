import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../firebase_options.dart';

import '../pages/home_page.dart';
import '../pages/cart_page.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';
import '../pages/splash_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/reset_password_page.dart';
import '../pages/course_details_page.dart';
import '../pages/purchased_courses_page.dart';

import '../services/pref.service.dart';

import '../utils/color_utilis.dart';

import '../bloc/course/course_bloc.dart';
import '../bloc/lecture/lecture_bloc.dart';

import '../cubit/pay/pay_cubit.dart';
import '../cubit/cart/cart_cubit.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/image/image_cubit.dart';

void main() async {
  BindingBase.debugZoneErrorsAreFatal;
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Failed to initialize Firebase: $e');
    }
  }
  await dotenv.load(fileName: ".env");
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (ctx) => AuthCubit(CartCubit())),
      BlocProvider(create: (ctx) => CartCubit()),
      BlocProvider(create: (ctx) => PayCubit()),
      BlocProvider(create: (ctx) => ImageCubit()),
      BlocProvider(create: (ctx) => CourseBloc()),
      BlocProvider(create: (ctx) => LectureBloc()),
    ],
    child: DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    ),
    // child: const MyApp()),
    // );
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        //  ignore: deprecated_member_use
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        scrollBehavior: _CustomScrollBehaviour(),
        debugShowCheckedModeBanner: false,
        title: 'Edu Vista',
        theme: ThemeData(
          scaffoldBackgroundColor: ColorUtility.gbScaffold,
          fontFamily: ' PlusJakartaSans',
          colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) {
          final String routeName = settings.name ?? '';
          final dynamic data = settings.arguments;

          switch (routeName) {
            case LoginPage.id:
              return MaterialPageRoute(builder: (context) => const LoginPage());
            case SignUpPage.id:
              return MaterialPageRoute(
                  builder: (context) => const SignUpPage());
            case ResetPasswordPage.id:
              return MaterialPageRoute(
                  builder: (context) => const ResetPasswordPage());
            case OnBoardingPage.id:
              return MaterialPageRoute(
                  builder: (context) => const OnBoardingPage());
            case HomePage.id:
              return MaterialPageRoute(builder: (context) => const HomePage());
            case CourseDetailsPage.id:
              return MaterialPageRoute(
                  builder: (context) => CourseDetailsPage(
                        course: data,
                      ));
            case CartPage.id:
              return MaterialPageRoute(builder: (context) => CartPage());
            case PurchasedCoursesPage.id:
              return MaterialPageRoute(
                  builder: (context) => PurchasedCoursesPage());
            default:
              return MaterialPageRoute(
                  builder: (context) => const SplashPage());
          }
        },
        initialRoute: SplashPage.id,
      ),
    );
  }
}

class _CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
