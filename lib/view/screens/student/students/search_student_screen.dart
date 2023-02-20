import 'package:duetstahall/data/model/response/student_model1.dart';
import 'package:duetstahall/provider/room_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/students/student_details_screen.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchStudentScreen extends StatelessWidget {
  SearchStudentScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Search Students"),
      body: AutofillGroup(
        child: Consumer2<StudentProvider, RoomProvider>(
            builder: (context, studentProvider, roomProvider, child) => GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'Search Student ID/Name',
                          isShowBorder: true,
                          verticalSize: 12,
                          isShowSuffixIcon: true,
                          isShowSuffixWidget: true,
                          controller: searchController,
                          inputAction: TextInputAction.done,
                          suffixWidget: InkWell(
                              onTap: () {
                                if (searchController.text.isEmpty) {
                                  showMessage('Please Enter a search term');
                                } else {
                                  studentProvider.callForSearchStudent(searchController.text);
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              child: const Icon(Icons.search, color: AppColors.primaryColorLight, size: 30)),
                        ),
                        studentProvider.isLoading
                            ? Container(height: 200, alignment: Alignment.center, child: const CircularProgressIndicator())
                            : studentProvider.searchStudents.isEmpty
                                ? Container(
                                    height: 200,
                                    alignment: Alignment.center,
                                    child: Text('No Students Records found', style: robotoStyle500Medium.copyWith(fontSize: 16)))
                                : Expanded(
                                    child: ListView.builder(
                                        itemCount: studentProvider.searchStudents.length,
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.only(top: 5),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Helper.toScreen(
                                                  StudentDetailsScreen(studentProvider.searchStudents[index].studentID.toString()));
                                            },
                                            child: searchStudentWidget(studentProvider.searchStudents[index]),
                                          );
                                        }),
                                  )
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}

Widget searchStudentWidget(StudentSubModel studentSubModel) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(bottom: 5, top: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))],
    ),
    child: Column(
      children: [
        singleItemWithKeyValue('Name:', studentSubModel.name!),
        const SizedBox(height: 2),
        singleItemWithKeyValue('Student-ID:', studentSubModel.studentID!.toString()),
        const SizedBox(height: 2),
        singleItemWithKeyValue('Department:', studentSubModel.department!),
      ],
    ),
  );
}
