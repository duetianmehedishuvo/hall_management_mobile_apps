
import 'package:auto_size_text/auto_size_text.dart';
import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/dining/widgets/custome_text_fields.dart';
import 'package:duetstahall/dining/widgets/rounded_button.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  const UpdateUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserProfileScreen> createState() => _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
  final banners = [ImagesModel.loginBannerOne, ImagesModel.loginBannerTwo];

  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController departmentController;
  late TextEditingController roomController;
  late TextEditingController phoneController;
  late TextEditingController fingerIDController;
  late TextEditingController rfIDController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  FocusNode idFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode departmentFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode bloodFocus = FocusNode();
  FocusNode fingerFocus = FocusNode();
  FocusNode rfFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode roomFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idController = TextEditingController();
    nameController = TextEditingController();
    departmentController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    fingerIDController = TextEditingController();
    rfIDController = TextEditingController();
    roomController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorLight,
      appBar: const CustomAppBar(title: "Update Student"),
      body: AutofillGroup(
        child: Consumer2<AuthProvider, StudentProvider>(builder: (context, authProvider, studentProvider, child) {
          int status = 0;
          if (!studentProvider.isLoading && status == 0) {
            idController.text = studentProvider.studentModel.studentID!;
            nameController.text = studentProvider.studentModel.name!;
            departmentController.text = studentProvider.studentModel.department!;
            phoneController.text = studentProvider.studentModel.phoneNumber!;
            fingerIDController.text = studentProvider.studentModel.fingerID!;
            rfIDController.text = studentProvider.studentModel.rfID!;
            roomController.text = studentProvider.studentModel.roomNO!.toString();
            status = 1;
          }

          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
              margin: const EdgeInsets.only(left: 6, right: 6),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: !studentProvider.isLoading
                  ? ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        CustomTextField(
                          hintText: 'Student ID',
                          isShowBorder: true,
                          controller: idController,
                          verticalSize: 14,
                          fillColor: Colors.grey.withOpacity(.1),
                          labelText: 'Student ID',
                          isEnabled: false,
                          focusNode: idFocus,
                          nextFocus: nameFocus,
                          inputType: TextInputType.number,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: 'Room No',
                          controller: roomController,
                          verticalSize: 14,
                          isEnabled: false,
                          fillColor: Colors.grey.withOpacity(.1),
                          labelText: 'Room NO',
                          inputType: TextInputType.number,
                          focusNode: roomFocus,
                          nextFocus: phoneFocus,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Finger Print ID',
                            isShowBorder: true,
                            focusNode: fingerFocus,
                            nextFocus: rfFocus,
                            isEnabled: false,
                            fillColor: Colors.grey.withOpacity(.1),
                            labelText: 'Finger Print ID',
                            controller: fingerIDController,
                            inputType: TextInputType.text,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'RF ID',
                            isShowBorder: true,
                            focusNode: rfFocus,
                            isEnabled: false,
                            fillColor: Colors.grey.withOpacity(.1),
                            labelText: 'RF ID',
                            nextFocus: passwordFocus,
                            controller: rfIDController,
                            inputType: TextInputType.text,
                            verticalSize: 14),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Name',
                            isShowBorder: true,
                            focusNode: nameFocus,
                            labelText: 'Name',
                            nextFocus: phoneFocus,
                            controller: nameController,
                            verticalSize: 14),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Phone',
                            isShowBorder: true,
                            controller: phoneController,
                            focusNode: phoneFocus,
                            labelText: 'Phone Number',
                            nextFocus: passwordFocus,
                            inputType: TextInputType.phone,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(245, 246, 248, 1),
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(color: CupertinoColors.systemGrey)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Blood Group: ', style: headline4),
                              SizedBox(
                                width: 55,
                                child: DropdownButton<String>(
                                  items: authProvider.bloodGroups.map((blood) {
                                    return DropdownMenuItem<String>(value: blood, child: Text(blood, style: headline4, textAlign: TextAlign.center));
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                  isExpanded: false,
                                  value: authProvider.selectedBlood,
                                  onChanged: (value) async {
                                    authProvider.changeBloodGroups(value!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        //password
                        CustomTextField(
                          hintText: 'Password',
                          controller: passwordController,
                          isPassword: true,
                          isShowBorder: true,
                          focusNode: passwordFocus,
                          nextFocus: confirmPasswordFocus,
                          isShowSuffixIcon: true,
                          labelText: 'Current Password',
                          autoFillHints: AutofillHints.password,
                          isSaveAutoFillData: true,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        //password
                        CustomTextField(
                          hintText: 'Password',
                          controller: confirmPasswordController,
                          isPassword: true,
                          isShowBorder: true,
                          focusNode: confirmPasswordFocus,
                          isShowSuffixIcon: true,
                          labelText: 'Confirm Password',
                          inputAction: TextInputAction.done,
                          autoFillHints: AutofillHints.password,
                          isSaveAutoFillData: true,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),

                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: RoundedButton(
                                    onPress: () {
                                      StudentModel student = StudentModel(
                                          name: nameController.text,
                                          department: studentProvider.studentModel.department,
                                          bloodGroup: authProvider.selectedBlood,
                                          fingerID: studentProvider.studentModel.fingerID,
                                          password: studentProvider.studentModel.password,
                                          phoneNumber: phoneController.text,
                                          rfID: studentProvider.studentModel.rfID,
                                          studentID: studentProvider.studentModel.studentID,
                                          allowableMeal: studentProvider.studentModel.allowableMeal,
                                          roomNO: studentProvider.studentModel.roomNO);

                                      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
                                        showMessage('please fill up all fields');
                                      } else if (nameController.text.isNotEmpty &&
                                          phoneController.text.isNotEmpty &&
                                          passwordController.text.isNotEmpty &&
                                          confirmPasswordController.text.isNotEmpty) {
                                        student.password = confirmPasswordController.text;
                                        studentProvider.checkPassword(passwordController.text).then((value) {
                                          if (value) {
                                            studentProvider.addStudent(student).then((value) {
                                              if (value) {
                                                showMessage('Update Successfully', isError: false);
                                              } else {
                                                showMessage('Failed TO Update');
                                              }
                                            });
                                          } else {
                                            showMessage('Password Not Found');
                                          }
                                        });
                                      } else if (passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) {
                                        student.password = confirmPasswordController.text;
                                        student.name = nameController.text;
                                        student.phoneNumber = phoneController.text;
                                        studentProvider.checkPassword(passwordController.text).then((value) {
                                          if (value) {
                                            studentProvider.addStudent(student).then((value) {
                                              if (value) {
                                                showMessage('Password Update Successfully', isError: false);
                                              } else {
                                                showMessage('Failed TO Update');
                                              }
                                            });
                                          } else {
                                            showMessage('Password Not Found');
                                          }
                                        });
                                      } else if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                                        studentProvider.addStudent(student).then((value) {
                                          if (value) {
                                            showMessage('Update Successfully', isError: false);
                                          } else {
                                            showMessage('Failed TO Update');
                                          }
                                        });
                                      }
                                    },
                                    boarderRadius: 8,
                                    backgroundColor: MaterialStateProperty.all(Colors.black),
                                    child:  AutoSizeText(
                                      "Update",
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 2),
                            //sign in with google
                          ],
                        ),
                      ],
                    )
                  : const CustomLoader(),
            ),
          );
        }),
      ),
    );
  }
}
