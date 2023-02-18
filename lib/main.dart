import 'package:duetstahall/view/screens/splash_screen.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/splash_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/translations/codegen_loader.g.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyB3h7zgPwVOpK4uZGQyqZSRwfU-UWRcGCU',
          appId: '1:170958571155:android:0f1d86d139c758457a2f66',
          messagingSenderId: '170958571155',
          projectId: 'duet-sta-hall-610b8'));
  await EasyLocalization.ensureInitialized();
  await di.init();
  runApp(EasyLocalization(
      path: 'assets/lang',
      supportedLocales: const [Locale('en'), Locale('bn')],
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<StudentProvider>()),
        ],
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'DUET STA-Hall',
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      navigatorKey: Helper.navigatorKey,
      // theme: Provider.of<ThemeProvider>(context).darkTheme ? AppTheme.getDarkModeTheme() : AppTheme.getLightModeTheme(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
      ),
      home: const SplashScreen(),
    );
  }
}
