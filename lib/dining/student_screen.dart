
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/dining/widgets/custome_text_fields.dart';
import 'package:duetstahall/dining/widgets/student_widget.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/dimensions.dart';
import 'package:duetstahall/util/string_resources.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentScreen extends StatelessWidget {
  final bool isUpdateMealCount;
  final bool isDelete;

  const StudentScreen({this.isUpdateMealCount = false, this.isDelete = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<StudentProvider>(context, listen: false).initializeAllStudent();
    return Scaffold(
      appBar: CustomAppBar(title: isUpdateMealCount ? "Add Student Meal" : "Students List", isRefreshEnable: true),
      body: Consumer<StudentProvider>(builder: (context, studentProvider, child) {
        return !studentProvider.isLoading
            ? Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: CustomTextField(
                        hintText: 'Student ID/Name/Room No',
                        labelText: 'Search Student',
                        isShowBorder: true,
                        suffixWidget: Icon(Icons.search),
                        isShowSuffixWidget: true,
                        isSearchStudent: true),
                  ),
                  studentProvider.studentList.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: studentProvider.studentList.length,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(top: 20),
                              itemBuilder: (context, index) {
                                return studentWidget(context, studentProvider.studentList[index], isUpdateMealCount,isDelete);
                              }),
                        )
                      : Column(
                          children: [
                            const SizedBox(height:25),
                            Text(Strings.sorry, style: headline4.copyWith(fontSize: 30, color: AppColors.primaryColorLight)),
                            const SizedBox(height: 5),
                            const Text('No data found', textAlign: TextAlign.center, style: headline4),
                          ],
                        )
                ],
              )
            : const CustomLoader();
      }),
    );
  }
}
