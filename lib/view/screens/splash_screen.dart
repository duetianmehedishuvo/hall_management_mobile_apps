import 'dart:async';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/settings_provider.dart';
import 'package:duetstahall/view/screens/admin/dashboard/admin_dashboard_screen.dart';
import 'package:duetstahall/view/screens/auth/signin_screen.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/student_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _route();
  }

  void _route() {
    Timer(const Duration(seconds: 4), () async {
      if (Provider.of<AuthProvider>(context, listen: false).getUserToken().isEmpty) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
      } else {
        Provider.of<AuthProvider>(context, listen: false).getUserInfo(isFirstTime: false);
        Provider.of<SettingsProvider>(context, listen: false).getConfigData();
        if (Provider.of<AuthProvider>(context, listen: false).userStatus == 0) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const StudentDashboardScreen()), (route) => false);
        } else if (Provider.of<AuthProvider>(context, listen: false).userStatus == 1) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()), (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context));

    return Scaffold(
      backgroundColor: AppColors.primaryColorLight,
      body: Stack(
        children: <Widget>[
          Align(child: Hero(tag: "Logo", child: Image.asset(ImagesModel.splashImage, gaplessPlayback: false))),
          Positioned(
              bottom: 20,
              right: 65,
              child: Text('E-Hall:Cost Effective IOT based Smart Hall',
                  style: headline3.copyWith(color: AppColors.whiteColorDark, fontSize: 15))),
          const Positioned(bottom: 40, right: 30, child: CustomLoader(color: AppColors.whiteColorDark))
        ],
      ),
    );
  }
}
