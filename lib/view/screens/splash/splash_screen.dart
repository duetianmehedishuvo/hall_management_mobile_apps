import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/admin/student/all_student_screen.dart';
import 'package:duetstahall/view/screens/admin/student/create_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../util/sizeConfig.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool connection = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      // Navigator.of(context).push(MaterialPageRoute(builder: (_) =>  CreateStudentScreen()));
      Navigator.of(context).push(MaterialPageRoute(builder: (_) =>  AddStudentScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Center(child: Lottie.asset('assets/animations/student_animation1.json'))),
          BounceInDown(
              child: Text(
            "Welcome to",
            style: latoStyle800ExtraBold.copyWith(color: AppColors.timeColor, fontSize: 22),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BounceInDown(
                  duration: const Duration(seconds: 2),
                  child: Text("DUET ", style: latoStyle800ExtraBold.copyWith(color: AppColors.feedback, fontSize: 22))),
              BounceInUp(
                  duration: const Duration(seconds: 2),
                  child: Text("STA ", style: latoStyle800ExtraBold.copyWith(color: AppColors.feedback, fontSize: 22))),
              BounceInDown(
                  duration: const Duration(seconds: 2),
                  child: Text("HALL ", style: latoStyle800ExtraBold.copyWith(color: AppColors.feedback, fontSize: 22))),
            ],
          ),
        ],
      ),
    );
  }
//
// void navigate() async {
//   bool result = await InternetConnectionChecker().hasConnection;
//   if (result == true) {
//     // ignore: use_build_context_synchronously
//     Provider.of<SplashProvider>(context, listen: false).initializeVersion();
//     Future.delayed(const Duration(seconds: 5), () {
//       if (Provider.of<AuthProvider>(context, listen: false)
//           .getUserToken()
//           .isEmpty) {
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (_) => const LoginScreen()),
//             (route) => false);
//       } else {
//         Provider.of<NotificationProvider>(context, listen: false).check();
//         Provider.of<AuthProvider>(context, listen: false).getUserInfo();
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             (route) => false);
//         Provider.of<ProfileProvider>(context, listen: false)
//             .initializeUserData();
//       }
//     });
//   } else {
//     //Helper.toScreen(const NoInternetScreen());
//     Provider.of<SplashProvider>(context, listen: false).initializeVersion();
//     Future.delayed(const Duration(seconds: 5), () {
//       if (Provider.of<AuthProvider>(context, listen: false)
//           .getUserToken()
//           .isEmpty) {
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (_) => const LoginScreen()),
//             (route) => false);
//       } else {
//         Provider.of<NotificationProvider>(context, listen: false).check();
//         Provider.of<AuthProvider>(context, listen: false).getUserInfo();
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             (route) => false);
//         Provider.of<ProfileProvider>(context, listen: false)
//             .initializeUserData();
//       }
//     });
//   }
// }
}
