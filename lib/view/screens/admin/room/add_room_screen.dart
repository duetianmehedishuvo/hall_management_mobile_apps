import 'package:duetstahall/provider/room_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRoomScreen extends StatelessWidget {
  AddRoomScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<RoomProvider>(context, listen: false).initializeYears();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Assign Students"),
      body: AutofillGroup(
        child: Consumer2<StudentProvider, RoomProvider>(
            builder: (context, studentProvider, roomProvider, child) => GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 45,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(245, 246, 248, 1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: CupertinoColors.systemGrey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Selected Rooms: ', style: headline4),
                              Text(roomProvider.selectedRooms.toString(), style: headline4),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 45,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(245, 246, 248, 1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: CupertinoColors.systemGrey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Select Years: ', style: headline4),
                              SizedBox(
                                width: 65,
                                child: DropdownButton<int>(
                                  items: roomProvider.years.map((year) {
                                    return DropdownMenuItem<int>(
                                        value: year, child: Text(year.toString(), style: headline4, textAlign: TextAlign.center));
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                  isExpanded: false,
                                  value: roomProvider.selectYears,
                                  onChanged: (value) async {
                                    roomProvider.changeYear(value!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 45,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(245, 246, 248, 1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: CupertinoColors.systemGrey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Selected Student: ', style: headline4),
                              Text(studentProvider.selectStudentID, style: headline4),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        studentProvider.selectStudentID == 'none'
                            ? const SizedBox.shrink()
                            : roomProvider.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : CustomButton(
                                    btnTxt: 'Add',
                                    onTap: () {
                                      roomProvider.addRoom(studentProvider.selectStudentID).then((value){
                                        if(value==true){
                                          Helper.back();
                                        }
                                      });
                                    },
                                  ),
                        SizedBox(height: studentProvider.selectStudentID == 'none' ? 2 : 30),
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
                                : ListView.builder(
                                    itemCount: studentProvider.searchStudents.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(top: 5),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          studentProvider.changeSelectStudentID(index);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(bottom: 5, top: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.withOpacity(.2),
                                                  blurRadius: 10.0,
                                                  spreadRadius: 3.0,
                                                  offset: const Offset(0.0, 0.0))
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              singleItemWithKeyValue('Name:', studentProvider.searchStudents[index].name!),
                                              const SizedBox(height: 2),
                                              singleItemWithKeyValue(
                                                  'Student-ID:', studentProvider.searchStudents[index].studentID!.toString()),
                                              const SizedBox(height: 2),
                                              singleItemWithKeyValue('Department:', studentProvider.searchStudents[index].department!),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
