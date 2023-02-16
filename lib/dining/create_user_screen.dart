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

class CreateUserScreen extends StatefulWidget {
  final bool isDetails;
  final StudentModel? studentModel;

  const CreateUserScreen({this.isDetails = false, this.studentModel, Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final banners = [ImagesModel.loginBannerOne, ImagesModel.loginBannerTwo];

  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController departmentController;
  late TextEditingController roomController;
  late TextEditingController phoneController;
  late TextEditingController fingerIDController;
  late TextEditingController rfIDController;
  late TextEditingController passwordController;
  FocusNode idFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode departmentFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode bloodFocus = FocusNode();
  FocusNode fingerFocus = FocusNode();
  FocusNode rfFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
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
    if (widget.isDetails) {
      idController.text = widget.studentModel!.studentID!;
      nameController.text = widget.studentModel!.name!;
      departmentController.text = widget.studentModel!.department!;
      phoneController.text = widget.studentModel!.phoneNumber!;
      passwordController.text = widget.studentModel!.password!;
      fingerIDController.text = widget.studentModel!.fingerID!;
      rfIDController.text = widget.studentModel!.rfID!;
      roomController.text = widget.studentModel!.roomNO!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorLight,
      appBar: CustomAppBar(title: widget.isDetails ? "Details Student" : "Create Student Database"),
      body: AutofillGroup(
        child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => GestureDetector(
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
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        CustomTextField(
                          hintText: 'Student ID',
                          isShowBorder: true,
                          controller: idController,
                          verticalSize: 14,
                          labelText: 'Student ID',
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
                            labelText: 'Name',
                            nextFocus: departmentFocus,
                            controller: nameController,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: 'Department',
                          controller: departmentController,
                          verticalSize: 14,
                          labelText: 'Department',
                          focusNode: departmentFocus,
                          nextFocus: roomFocus,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: 'Room No',
                          controller: roomController,
                          verticalSize: 14,
                          labelText: 'Room NO',
                          inputType: TextInputType.number,
                          focusNode: roomFocus,
                          nextFocus: phoneFocus,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Phone',
                            isShowBorder: true,
                            controller: phoneController,
                            focusNode: phoneFocus,
                            labelText: 'Phone Number',
                            nextFocus: bloodFocus,
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
                        CustomTextField(
                            hintText: 'Finger Print ID',
                            isShowBorder: true,
                            focusNode: fingerFocus,
                            nextFocus: rfFocus,
                            labelText: 'Finger Print ID',
                            controller: fingerIDController,
                            inputType: TextInputType.text,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'RF ID',
                            isShowBorder: true,
                            focusNode: rfFocus,
                            labelText: 'RF ID',
                            nextFocus: passwordFocus,
                            controller: rfIDController,
                            inputType: TextInputType.text,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),

                        //password
                        CustomTextField(
                          hintText: 'Password',
                          controller: passwordController,
                          isPassword: true,
                          isShowBorder: true,
                          focusNode: passwordFocus,
                          isShowSuffixIcon: true,
                          labelText: 'Password',
                          inputAction: TextInputAction.done,
                          autoFillHints: AutofillHints.password,
                          isSaveAutoFillData: true,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),

                        !authProvider.isLoading
                            ? Column(
                                children: [
                                  //SignIn
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RoundedButton(
                                          onPress: () {
                                            if (idController.text.isEmpty ||
                                                nameController.text.isEmpty ||
                                                departmentController.text.isEmpty ||
                                                phoneController.text.isEmpty ||
                                                fingerIDController.text.isEmpty ||
                                                rfIDController.text.isEmpty ||
                                                roomController.text.isEmpty ||
                                                passwordController.text.isEmpty) {
                                              showMessage('please fill up all fields');
                                            } else {
                                              StudentModel student = StudentModel(
                                                  name: nameController.text,
                                                  department: departmentController.text,
                                                  bloodGroup: authProvider.selectedBlood,
                                                  fingerID: fingerIDController.text,
                                                  password: passwordController.text,
                                                  phoneNumber: phoneController.text,
                                                  rfID: rfIDController.text,
                                                  studentID: idController.text,
                                                  allowableMeal: 0,
                                                  roomNO: int.parse(roomController.text));

                                              authProvider.addStudent(student).then((value) {
                                                if (value) {
                                                  showMessage('Student ${widget.isDetails ? "Update" : "Registration"} Successfully',
                                                      isError: false);

                                                  if (!widget.isDetails) {
                                                    idController.text = '';
                                                    nameController.text = '';
                                                    departmentController.text = '';
                                                    phoneController.text = '';
                                                    passwordController.text = '';
                                                    fingerIDController.text = '';
                                                    rfIDController.text = '';
                                                    roomController.text = '';
                                                  } else {
                                                    Provider.of<StudentProvider>(context, listen: false).initializeAllStudent();
                                                  }
                                                } else {
                                                  showMessage('Student Registration Failed');
                                                }
                                              });
                                            }
                                          },
                                          boarderRadius: 8,
                                          backgroundColor: MaterialStateProperty.all(Colors.black),
                                          child: AutoSizeText(
                                            widget.isDetails ? "Update" : "Submit",
                                            style: const TextStyle(color: Colors.white, fontSize: 14),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                  //sign in with google
                                ],
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
