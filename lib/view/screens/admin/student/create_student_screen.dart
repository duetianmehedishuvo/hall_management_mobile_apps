import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_loader.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateStudentScreen extends StatefulWidget {
  final bool isDetails;
  final StudentModel? studentModel;

  const CreateStudentScreen({this.isDetails = false, this.studentModel, Key? key}) : super(key: key);

  @override
  State<CreateStudentScreen> createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController departmentController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  FocusNode idFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode departmentFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode bloodFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idController = TextEditingController();
    nameController = TextEditingController();
    departmentController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    if (widget.isDetails) {
      idController.text = widget.studentModel!.studentID!.toString();
      nameController.text = widget.studentModel!.name!;
      departmentController.text = widget.studentModel!.department!;
      // phoneController.text = widget.studentModel!.phoneNo!;
      passwordController.text = widget.studentModel!.password!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColorDark,
      appBar: CustomAppBar(title: widget.isDetails ? "Details Student" : "Create Student Database"),
      body: AutofillGroup(
        child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        CustomTextField(
                          hintText: 'Student ID',
                          isShowBorder: true,
                          controller: idController,
                          verticalSize: 14,
                          isEnabled: !widget.isDetails,
                          focusNode: idFocus,
                          nextFocus: nameFocus,
                          inputType: TextInputType.number,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Name',
                            isShowBorder: true,
                            focusNode: nameFocus,
                            nextFocus: departmentFocus,
                            controller: nameController,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: 'Department',
                          controller: departmentController,
                          verticalSize: 14,
                          focusNode: departmentFocus,
                          nextFocus: phoneFocus,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Phone',
                            isShowBorder: true,
                            controller: phoneController,
                            focusNode: phoneFocus,
                            nextFocus: bloodFocus,
                            inputType: TextInputType.phone,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 45,
                          decoration: BoxDecoration(
                              color: AppColors.imageBGColorLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: CupertinoColors.systemGrey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Blood Group: ', style: headline4),
                              SizedBox(
                                width: 55,
                                child: DropdownButton<String>(
                                  items: authProvider.bloodGroups.map((blood) {
                                    return DropdownMenuItem<String>(
                                        value: blood, child: Text(blood, style: headline4, textAlign: TextAlign.center));
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

                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          height: 45,
                          decoration: BoxDecoration(
                              color: AppColors.imageBGColorLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: CupertinoColors.systemGrey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Joining DATE:  ', style: headline4),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: CustomButton(
                                      onTap: () {
                                        // authProvider.selectDate();
                                      },
                                      radius: 15,
                                      backgroundColor: AppColors.imageBGColorLight,
                                      textWhiteColor: false,
                                      // btnTxt: DateConverter.localDateToIsoString(authProvider.selectedDate)
                                  ),
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
                          isShowSuffixIcon: true,
                          inputAction: TextInputAction.done,
                          autoFillHints: AutofillHints.password,
                          isSaveAutoFillData: true,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),

                        !authProvider.isLoading
                            ? CustomButton(
                                onTap: () {
                                  if (idController.text.isEmpty ||
                                      nameController.text.isEmpty ||
                                      departmentController.text.isEmpty ||
                                      phoneController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    showMessage('please fill up all fields');
                                  } else {
                                    StudentModel student = StudentModel(
                                        name: nameController.text,
                                        department: departmentController.text,
                                        bloodGroup: authProvider.selectedBlood,
                                        password: passwordController.text,
                                        // phoneNo: phoneController.text,
                                        studentID: idController.text,
                                        // image: '',
                                        // address: '',
                                        // aboutMe: '',
                                        // admissionDate: DateConverter.localDateToIsoString(authProvider.selectedDate),
                                        // jobPosition: '',
                                        // userRoll: 0
                                    );

                                    // authProvider.addStudent(student);
                                  }
                                },
                                btnTxt: widget.isDetails ? "Update" : "Submit",
                              )
                            : const CustomLoader(),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
