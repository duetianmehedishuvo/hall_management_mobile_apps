import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileViewWidget extends StatelessWidget {
  const ProfileViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, StudentProvider>(
      builder: (context, authProvider, studentProvider, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        margin: const EdgeInsets.only(bottom: 22),
        decoration: const BoxDecoration(
            color: AppColors.primaryColorLight,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
                right: -28, bottom: 0, child: Image.asset("assets/images/profile_picturee.png", height: 80, width: 100)),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Welcome, ${studentProvider.studentModel.name}",
                      style: headline4.copyWith(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 5),
                  Text('Available Meal:  ${studentProvider.studentModel.allowableMeal}',
                      style: headline5.copyWith(color: AppColors.whiteColorDark.withOpacity(.8))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
