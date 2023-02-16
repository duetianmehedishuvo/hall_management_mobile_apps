import 'package:duetstahall/helper/database_helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/view/screens/admin/room/add_room_screen.dart';
import 'package:duetstahall/view/screens/admin/student/create_student_screen.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColorDark,
      appBar: const CustomAppBar(title: "Home"),
      body: Column(
        children: [
          CustomButton(
              btnTxt: 'Add Student',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) =>  const CreateStudentScreen()));
              }),
          CustomButton(
              btnTxt: 'Add Room',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) =>  const AddRoomScreen()));
              }),
          CustomButton(
              btnTxt: 'SHow all Students',
              onTap: () {
                final DatabaseHelper databaseService = DatabaseHelper();
                databaseService.allStudents().then((value) {
                  for (var v in value) {
                    // print(v.toMap());
                  }
                });
              }),
          CustomButton(
              btnTxt: 'SHow all Rooms',
              onTap: () {
                final DatabaseHelper databaseService = DatabaseHelper();
                databaseService.allRooms().then((value) {
                  for (var v in value) {
                    print(v.toMap());
                  }
                });
              }),
        ],
      ),
    );
  }
}
