
import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/dining/add_meal_screen.dart';
import 'package:duetstahall/dining/widgets/animated_custom_dialog.dart';
import 'package:duetstahall/dining/widgets/guest_dialog.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';

Widget studentWidget(BuildContext context, StudentModel studentModel, bool isUpdateMealCount, bool isDelete) {
  return MaterialButton(
    onPressed: () {
      if (isUpdateMealCount) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddMealScreen(studentModel: studentModel)));
      } else if (isDelete) {
        showAnimatedDialog(context, GuestDialog(isRemove: true, studentID: studentModel.studentID!), isFlip: false);
      } else {
        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignupScreen(isDetails: true, studentModel: studentModel)));
      }
    },
    child: Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColorLight.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ID: ${studentModel.studentID}', style: headline4.copyWith(fontSize: 15)),
              Text('Room-No: ${studentModel.roomNO}', style: headline3.copyWith(fontSize: 13, color: AppColors.primaryColorLight.withOpacity(.7))),
            ],
          ),
          const SizedBox(height: 5),
          Text('Name: ${studentModel.name}', style: bodyText1.copyWith(fontSize: 15)),
          const SizedBox(height: 3),
          Text('Allowable Meal Count: ${studentModel.allowableMeal}', style: bodyText2.copyWith(fontSize: 14, color: AppColors.black)),
        ],
      ),
    ),
  );
}
