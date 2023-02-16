import 'dart:async';
import 'package:duetstahall/dining/signin.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';

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
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
              child: Text('DUET Hall Management System', style: headline3.copyWith(color: AppColors.whiteColorDark, fontSize: 15))),
           Positioned(bottom: 40, right: 30, child: CustomLoader(color: AppColors.whiteColorDark))
        ],
      ),
    );
  }
}
