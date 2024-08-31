import 'dart:developer';
import 'dart:io';
import 'dart:ui';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:ip_tv_app/pages/find.dart';
import 'package:ip_tv_app/pages/home.dart';
import 'package:ip_tv_app/pages/login_screen.dart';
import 'package:ip_tv_app/pages/splash.dart';
import 'package:ip_tv_app/provider/channelsectionprovider.dart';
import 'package:ip_tv_app/provider/episodeprovider.dart';
import 'package:ip_tv_app/provider/findprovider.dart';
import 'package:ip_tv_app/provider/generalprovider.dart';
import 'package:ip_tv_app/provider/homeprovider.dart';
import 'package:ip_tv_app/provider/playerprovider.dart';
import 'package:ip_tv_app/provider/profileprovider.dart';
import 'package:ip_tv_app/provider/rentstoreprovider.dart';
import 'package:ip_tv_app/provider/searchprovider.dart';
import 'package:ip_tv_app/provider/sectionbytypeprovider.dart';
import 'package:ip_tv_app/provider/sectiondataprovider.dart';
import 'package:ip_tv_app/provider/showdetailsprovider.dart';
import 'package:ip_tv_app/provider/videobyidprovider.dart';
import 'package:ip_tv_app/provider/videodetailsprovider.dart';
import 'package:ip_tv_app/provider/watchlistprovider.dart';
import 'package:ip_tv_app/utils/color.dart';
import 'package:ip_tv_app/utils/constant.dart';
import 'package:ip_tv_app/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'ar', 'hi']);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GeneralProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => PlayerProvider()),
          ChangeNotifierProvider(create: (_) => FindProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => RentStoreProvider()),
          ChangeNotifierProvider(create: (_) => SearchProvider()),
          ChangeNotifierProvider(create: (_) => SectionByTypeProvider()),
          ChangeNotifierProvider(create: (_) => SectionDataProvider()),
          ChangeNotifierProvider(create: (_) => ChannelSectionProvider()),
          ChangeNotifierProvider(create: (_) => ShowDetailsProvider()),
          ChangeNotifierProvider(create: (_) => EpisodeProvider()),
          ChangeNotifierProvider(create: (_) => VideoByIDProvider()),
          ChangeNotifierProvider(create: (_) => VideoDetailsProvider()),
          ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HomeProvider homeProvider;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _getDeviceInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          primaryColorDark: primaryDarkColor,
          primaryColorLight: primaryLight,
          scaffoldBackgroundColor: appBgColor,
        ).copyWith(
          scrollbarTheme: const ScrollbarThemeData().copyWith(
            thumbColor: MaterialStateProperty.all(white),
            trackVisibility: MaterialStateProperty.all(true),
            trackColor: MaterialStateProperty.all(whiteTransparent),
          ),
          focusColor: Colors.grey,
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent),
            ),
          ),
        ),
        title: Constant.appName ?? "",
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          return locale;
        },
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 360, name: MOBILE),
              const Breakpoint(start: 361, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1000, name: DESKTOP),
              const Breakpoint(start: 1001, end: double.infinity, name: '4K'),
            ],
          );
        },
        home: const Splash(),
        routes: {"/find": (context) => const Find(),
          "/login": (context) => const LoginScreen(),},
        // home: const TestPageController(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
            PointerDeviceKind.trackpad
          },
        ),
      ),
    );
  }

  _getDeviceInfo() async {
    if (Platform.isAndroid) {
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // Constant.isTV = androidInfo.systemFeatures.contains('android.software.leanback');
      log("isTV =======================> ${Constant.isTV}");
    }
  }
}
