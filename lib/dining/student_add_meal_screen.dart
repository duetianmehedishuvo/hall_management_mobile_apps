import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_button.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentAddMealScreen extends StatelessWidget {
  final bool isDelete;

  const StudentAddMealScreen({this.isDelete = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<StudentProvider>(context, listen: false).initializeEmptyDates();
    Provider.of<StudentProvider>(context, listen: false).getAllDateForQuery();
    return Scaffold(
      appBar: CustomAppBar(title: '${isDelete ? "Remove" : "Add"} Meal'),
      body: Consumer<StudentProvider>(
          builder: (context, studentProvider, child) => !studentProvider.isLoadingMeal
              ? Column(
                  children: [
                    Expanded(
                        child: ListView(children: [
                      studentProvider.selectedDates.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColorLight.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: GridView.builder(
                                itemCount: studentProvider.selectedDates.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: (2), mainAxisSpacing: 1.3, crossAxisSpacing: 15, childAspectRatio: 2.9),
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 15),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColorDark,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                            DateConverter.isoStringToDatePushServer(studentProvider.selectedDates[index]),
                                            style: headline5.copyWith(fontSize: 14, color: AppColors.black)),
                                      ),
                                      Positioned(
                                          right: -0,
                                          top: -0,
                                          child: InkWell(
                                            onTap: () {
                                              studentProvider.removeDates(index);
                                            },
                                            child: const CircleAvatar(
                                                backgroundColor: AppColors.primaryColorLight,
                                                radius: 10,
                                                child: Icon(Icons.clear, color: AppColors.whiteColorDark, size: 15)),
                                          ))
                                    ],
                                  );
                                },
                              ),
                            )
                          : Column(
                              children: [
                                const SizedBox(height: 10),
                                Text('No Selected Date Found',
                                    style: headline4.copyWith(color: Colors.red), textAlign: TextAlign.center),
                                // const SizedBox(height: 20),
                              ],
                            ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 140,
                              child: CustomButton(
                                  btnTxt: 'Open Calender',
                                  onTap: () async {
                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().add(const Duration(days: 1)),
                                      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
                                      lastDate: DateTime(2101),
                                    );
                                    if (picked != null) {
                                      studentProvider.addDates(picked.toIso8601String(), context, isRemove: isDelete);
                                    }
                                  })),
                        ],
                      ),
                    ])),
                    studentProvider.selectedDates.isNotEmpty
                        ? CustomButton(
                            btnTxt: isDelete ? 'Remove' : "Save",
                            onTap: () {
                              studentProvider.uploadDateOnServer(context, isDelete);
                            },
                            radius: 0)
                        : const SizedBox.shrink(),
                  ],
                )
              : const CustomLoader()),
    );
  }
}
