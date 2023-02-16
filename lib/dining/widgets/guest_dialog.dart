import 'dart:io';

import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/dimensions.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../signin.dart';

class GuestDialog extends StatelessWidget {
  final bool isLogin;
  final bool isRemove;
  final String studentID;

  const GuestDialog({Key? key, this.isLogin = false, this.isRemove = false, this.studentID = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(clipBehavior: Clip.none, fit: StackFit.loose, children: [
        Positioned(
          left: 0,
          right: 0,
          top: -50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(ImagesModel.login, height: 80, width: 80),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Message', style: headline4.copyWith(fontSize: 16)),
              const SizedBox(height: 10),
              Text(
                  isLogin
                      ? "Are You Sure Want to Exit Application?"
                      : isRemove
                          ? "Are You Sure Want To Delete This Student"
                          : "Are You Sure Want To Logout?",
                  textAlign: TextAlign.center,
                  style: headline4),
              const SizedBox(height: 20),
              const Divider(height: 0, color: AppColors.hintTextColorDark),
              Row(children: [
                Expanded(
                    child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                    child: Text('Cancel', style: headline4.copyWith(color: AppColors.primaryColorLight)),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (isLogin) {
                      exit(0);
                    } else if (isRemove) {
                      Provider.of<StudentProvider>(context, listen: false).removeStudent(studentID, context);
                      Navigator.of(context).pop();
                    } else {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColorLight, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                    child: Text('Yes', style: headline4.copyWith(color: AppColors.whiteColorDark)),
                  ),
                )),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
