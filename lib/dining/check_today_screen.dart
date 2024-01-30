import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duetstahall/dining/check_student_meal_screen.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckTodayScreen extends StatefulWidget {
  final bool isToday;

  const CheckTodayScreen({this.isToday = true, super.key});

  @override
  State<CheckTodayScreen> createState() => _CheckTodayScreenState();
}

class _CheckTodayScreenState extends State<CheckTodayScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<StudentProvider>(context, listen: false).getTodayMeal(
        DateConverter.localDateToIsoString(widget.isToday ? DateTime.now() : DateTime.now().add(const Duration(days: 1))), widget.isToday);
    return Scaffold(
      appBar: CustomAppBar(title: 'Check ${widget.isToday ? "Today's" : "Tomorrow"}  Meal'),
      body: StreamBuilder<QuerySnapshot>(
          stream: mealRateCollection.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            return Consumer<StudentProvider>(builder: (context, studentProvider, child) {
              return !studentProvider.isLoadingCheckTodays
                  ? Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 2, child: Text("Total User Meal: ", style: headline4.copyWith())),
                              Expanded(child: Text("${studentProvider.ids.length} P", style: headline2.copyWith(color: AppColors.primaryColorLight))),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex: 2, child: Text("Total Guest Meal: ", style: headline4.copyWith())),
                              Expanded(child: Text("${studentProvider.guestMealCount} P", style: headline2.copyWith(color: AppColors.primaryColorLight))),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(flex: 2, child: Text("Total Meal: ", style: headline4.copyWith())),
                              Expanded(
                                  child: Text("${studentProvider.guestMealCount + studentProvider.ids.length} P",
                                      style: headline2.copyWith(color: AppColors.primaryColorLight))),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(left: 10, top: 10,bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColorDark,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Expanded( child: Text("Total TK: ", style: headline4.copyWith())),
                                Expanded(
                                    child: Text(
                                        "${snapshot.data!.docs[0]['meal-rate']}৳ * ${(studentProvider.guestMealCount + studentProvider.ids.length)} P\n=${(studentProvider.guestMealCount + studentProvider.ids.length) * snapshot.data!.docs[0]['meal-rate']} ৳",
                                        style: headline2.copyWith(color: AppColors.primaryColorLight))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(child: Text("Students IDS: ", style: headline3.copyWith())),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                                itemCount: studentProvider.allMeals.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => CheckStudentMealScreen(
                                                studentID: studentProvider.allMeals[index]['student_id'],
                                              )));
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: studentProvider.allMeals[index]['guest_meal'] != 0 ? AppColors.lightGrey : AppColors.whiteColorDark,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primaryColorLight.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
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
                                                Text(
                                                  'ID: ${studentProvider.allMeals[index]['student_id']}',
                                                  style: headline4.copyWith(color: AppColors.black, fontSize: 16),
                                                ),
                                                Text(
                                                  'Room: ${studentProvider.allMeals[index]['room_no']}',
                                                  style: bodyText1.copyWith(color: AppColors.black, fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Name: ${studentProvider.allMeals[index]['name']}',
                                              style: headline5.copyWith(color: AppColors.black, fontSize: 16),
                                            ),
                                            const SizedBox(height: 5),
                                            studentProvider.allMeals[index]['guest_meal'] != 0
                                                ? Text(
                                                    'Guest Meal Available',
                                                    style: headline5.copyWith(color: AppColors.primaryColorLight, fontSize: 16),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        )),
                                  );
                                }),
                          )
                        ],
                      ),
                    )
                  : const CustomLoader();
            });
          }),
    );
  }
}
