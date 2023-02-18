import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/dining/widgets/animated_button.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/dining/widgets/custome_text_fields.dart';
import 'package:duetstahall/dining/widgets/settings_button.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMealScreen extends StatefulWidget {
  final StudentModel? studentModel;

  const AddMealScreen({this.studentModel, Key? key}) : super(key: key);

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  TextEditingController mealCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add/Remove Student Meal'),
      body: Consumer<StudentProvider>(builder: (context, studentProvider, child) {
        return !studentProvider.isLoading
            ? Column(
                children: [
                  Expanded(
                    //DO your ui design
                    // I am keeping it blank for the demo
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'Quantity',
                          labelText: 'Enter Meal Count',
                          isShowBorder: true,
                          borderRadius: 9,
                          verticalSize: 14,
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.done,
                          controller: mealCountController,
                        ),
                        const SizedBox(height: 20),
                        SettingsButton(
                            icon: Icons.info,
                            labelKey: "Remove Meal",
                            onClick: () {},
                            hideDivider: true,
                            color: Colors.teal,
                            hintWidget: Row(
                              children: [
                                Text("Off/On", style: Theme.of(context).textTheme.bodyText1),
                                Switch(
                                    value: studentProvider.isMealOn,
                                    activeColor: Colors.green,
                                    onChanged: (s) {
                                      studentProvider.changeMealOn(s);
                                    }),
                              ],
                            )),
                        const SizedBox(height: 20),
                        Center(
                            child: Text('Student Information:',
                                style: headline4.copyWith(fontSize: 15, decoration: TextDecoration.underline))),
                        const SizedBox(height: 10),
                        itemWidget("Student ID:", widget.studentModel!.studentID!),
                        Container(color: AppColors.grey.withOpacity(.3), height: 1, margin: const EdgeInsets.only(top: 3, bottom: 2)),
                        itemWidget("Department:", widget.studentModel!.department!),
                        Container(color: AppColors.grey.withOpacity(.3), height: 1, margin: const EdgeInsets.only(top: 3, bottom: 2)),
                        itemWidget("Name:", widget.studentModel!.name!),
                        Container(color: AppColors.grey.withOpacity(.3), height: 1, margin: const EdgeInsets.only(top: 5, bottom: 2)),
                        itemWidget("Room No:", widget.studentModel!.roomNO!.toString()),
                        Container(color: AppColors.grey.withOpacity(.3), height: 1, margin: const EdgeInsets.only(top: 5, bottom: 2)),
                        itemWidget("Current Meal Count:", widget.studentModel!.allowableMeal!.toString()),
                        Container(color: AppColors.grey.withOpacity(.3), height: 1, margin: const EdgeInsets.only(top: 5, bottom: 2)),
                        itemWidget("Finger ID:", widget.studentModel!.fingerID!),
                        Container(color: AppColors.grey.withOpacity(.3), height: 1, margin: const EdgeInsets.only(top: 5, bottom: 2)),
                        itemWidget("RF ID:", widget.studentModel!.rfID!),
                        Container(color: AppColors.grey.withOpacity(.3), height: 1, margin: const EdgeInsets.only(top: 5, bottom: 2)),
                      ],
                    ),
                  ),
                  //Animated button
                  AnimatedButton(onComplete: () {
                    _onConfirmed(studentProvider);
                  })
                ],
              )
            : const CustomLoader();
      }),
    );
  }

  Widget itemWidget(String key, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(key, style: headline4.copyWith(fontSize: 16, color: AppColors.black)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: headline4.copyWith(fontSize: 16, color: AppColors.black.withOpacity(.8))))
        ],
      ),
    );
  }

  void _onConfirmed(StudentProvider studentProvider) {
    //Do your task whatever you want
    //As an example, Let's show a dummy dialog
    if (mealCountController.text.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      StudentModel studentModel = widget.studentModel!;
      if (studentProvider.isMealOn) {
        studentModel.allowableMeal = studentModel.allowableMeal! - (int.parse(mealCountController.text));
      } else {
        studentModel.allowableMeal = studentModel.allowableMeal! + (int.parse(mealCountController.text));
      }

      if (studentModel.allowableMeal! < 0) {
        showMessage('Please check allowable meal');
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return Material(
                type: MaterialType.transparency,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 72),
                    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check, color: AppColors.primaryColorLight, size: 96),
                        Center(
                          child: Text(
                            "Meal Added Successfully",
                            style: TextStyle(color: AppColors.primaryColorLight, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });

        // Provider.of<AuthProvider>(context, listen: false).addStudent(studentModel).then((value) {
        //   if (value) {
        //     mealCountController.text = '';
        //     Navigator.of(context).pop();
        //     Navigator.of(context).pop();
        //   } else {
        //     showMessage('Meal Added Failed');
        //   }
        // });
      }
    } else {
      showMessage('Meal Count Field is required');
    }
  }
}
