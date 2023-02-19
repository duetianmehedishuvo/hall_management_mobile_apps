import 'package:auto_size_text/auto_size_text.dart';
import 'package:duetstahall/data/model/response/student_model1.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/dining/widgets/custome_text_fields.dart';
import 'package:duetstahall/dining/widgets/rounded_button.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  final bool isDetails;
  final StudentModel1? studentModel;

  const SignupScreen({this.isDetails = false, this.studentModel, Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final banners = [ImagesModel.loginBannerOne, ImagesModel.loginBannerTwo];

  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController detailsController;
  late TextEditingController homeTownController;
  late TextEditingController thesisTopicController;
  late TextEditingController jobPositionController;
  late TextEditingController futureGoalController;
  late TextEditingController motiveController;
  late TextEditingController emailController;
  late TextEditingController whatsAppController;
  late TextEditingController passwordController;
  FocusNode idFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode detailsFocus = FocusNode();
  FocusNode homeTownFocus = FocusNode();
  FocusNode thesisFocus = FocusNode();
  FocusNode jobPositionFocus = FocusNode();
  FocusNode futureGoalFocus = FocusNode();
  FocusNode motiveFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode whatsAppFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    detailsController = TextEditingController();
    homeTownController = TextEditingController();
    thesisTopicController = TextEditingController();
    jobPositionController = TextEditingController();
    futureGoalController = TextEditingController();
    motiveController = TextEditingController();
    emailController = TextEditingController();
    whatsAppController = TextEditingController();
    passwordController = TextEditingController();

    if (widget.isDetails) {
      idController.text = widget.studentModel!.studentID!.toString();
      nameController.text = widget.studentModel!.name!;
      phoneController.text = widget.studentModel!.phoneNumber!;
      detailsController.text = widget.studentModel!.details.toString();
      homeTownController.text = widget.studentModel!.homeTown!;
      thesisTopicController.text = widget.studentModel!.researchArea!;
      jobPositionController.text = widget.studentModel!.jobPosition!;
      futureGoalController.text = widget.studentModel!.futureGoal!;
      motiveController.text = widget.studentModel!.motive!;
      emailController.text = widget.studentModel!.email!;
      whatsAppController.text = widget.studentModel!.whatssApp!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorLight,
      appBar: CustomAppBar(title: widget.isDetails ? "Update Your Bio" : "Create Account"),
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
                        color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                              const Expanded(child: Text('Departments: ', style: headline4)),
                              DropdownButton<String>(
                                items: authProvider.departments.map((dep) {
                                  return DropdownMenuItem<String>(
                                      value: dep, child: Text(dep, style: headline4, textAlign: TextAlign.center));
                                }).toList(),
                                underline: const SizedBox.shrink(),
                                isExpanded: false,
                                value: authProvider.selectedDepartments,
                                onChanged: (value) async {
                                  authProvider.changeDepartments(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
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
                            nextFocus: phoneFocus,
                            controller: nameController,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: 'Phone Number',
                          controller: phoneController,
                          verticalSize: 14,
                          labelText: 'Enter Your Phone Number',
                          focusNode: phoneFocus,
                          nextFocus: emailFocus,
                          inputType: TextInputType.number,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: 'Email',
                          controller: emailController,
                          verticalSize: 14,
                          labelText: 'Enter Your Email Address',
                          inputType: TextInputType.emailAddress,
                          focusNode: emailFocus,
                          nextFocus: whatsAppFocus,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: "Write What's App Number",
                          controller: whatsAppController,
                          verticalSize: 14,
                          labelText: 'What\'s App Number',
                          inputType: TextInputType.number,
                          focusNode: whatsAppFocus,
                          nextFocus: homeTownFocus,
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Hometown',
                            isShowBorder: true,
                            controller: homeTownController,
                            focusNode: homeTownFocus,
                            labelText: 'Enter your Hometown',
                            nextFocus: jobPositionFocus,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Job Title',
                            isShowBorder: true,
                            controller: jobPositionController,
                            focusNode: jobPositionFocus,
                            labelText: 'Job Title',
                            nextFocus: futureGoalFocus,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Future Goal',
                            isShowBorder: true,
                            controller: futureGoalController,
                            focusNode: futureGoalFocus,
                            labelText: 'Future Goal',
                            nextFocus: detailsFocus,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: 'Details',
                          controller: detailsController,
                          verticalSize: 14,
                          labelText: 'Enter Your Details',
                          inputType: TextInputType.text,
                          maxLines: 4,
                          focusNode: detailsFocus,
                          nextFocus: thesisFocus,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Thesis Topics',
                            isShowBorder: true,
                            controller: thesisTopicController,
                            focusNode: thesisFocus,
                            labelText: 'Thesis Topics',
                            maxLines: 3,
                            nextFocus: motiveFocus,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        CustomTextField(
                            hintText: 'Motive Your Juniors',
                            isShowBorder: true,
                            controller: motiveController,
                            focusNode: motiveFocus,
                            labelText: 'Motive Your Juniors',
                            maxLines: 3,
                            nextFocus: passwordFocus,
                            verticalSize: 14),
                        widget.isDetails ? SizedBox() : SizedBox(height: SizeConfig.blockSizeVertical * 2),

                        //password
                        widget.isDetails
                            ? SizedBox()
                            : CustomTextField(
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RoundedButton(
                                          onPress: () {
                                            String studentID = idController.text;
                                            String name = nameController.text;
                                            String phoneNumber = phoneController.text;
                                            String details = detailsController.text;
                                            String homeTown = homeTownController.text;
                                            String thesisTopic = thesisTopicController.text;
                                            String jobPosition = jobPositionController.text;
                                            String futureGoal = futureGoalController.text;
                                            String motive = motiveController.text;
                                            String email = emailController.text;
                                            String whatsApp = whatsAppController.text;
                                            String password = passwordController.text;

                                            if (idController.text.isEmpty) {
                                              showMessage('Student ID fill Required');
                                            } else if (nameController.text.isEmpty) {
                                              showMessage('name Fields is Required');
                                            } else if (phoneController.text.isEmpty) {
                                              showMessage('phone Fields is Required');
                                            } else {
                                              if (widget.isDetails) {
                                                authProvider
                                                    .updateStudentInfo(studentID, name, phoneNumber, details, homeTown, thesisTopic,
                                                        jobPosition, futureGoal, whatsApp, email, motive)
                                                    .then((value) {
                                                  if (value == true) {
                                                    Provider.of<StudentProvider>(context, listen: false).getStudentInfoByID(studentID);
                                                    Helper.back();
                                                  }
                                                });
                                              } else {
                                                if (passwordController.text.isEmpty) {
                                                  showMessage('password Fields is Required');
                                                } else {
                                                  authProvider
                                                      .signup(studentID, name, phoneNumber, password, details, homeTown, thesisTopic,
                                                          jobPosition, futureGoal, whatsApp, email, motive)
                                                      .then((value) {
                                                    if (value == true) {
                                                      Helper.back();
                                                    }
                                                  });
                                                }
                                              }
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
