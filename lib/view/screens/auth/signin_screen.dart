import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/dining/widgets/custome_text_fields.dart';
import 'package:duetstahall/dining/widgets/rounded_button.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/admin/dashboard/admin_dashboard_screen.dart';
import 'package:duetstahall/view/screens/auth/signup_screen.dart';
import 'package:duetstahall/view/screens/library/library_screen.dart';
import 'package:duetstahall/view/screens/medical/medical_home_screen.dart';
import 'package:duetstahall/view/screens/student/student_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final banners = [ImagesModel.loginBannerOne, ImagesModel.loginBannerTwo];

  late TextEditingController idController;

  late TextEditingController passwordController;
  FocusNode idFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idController = TextEditingController();
    passwordController = TextEditingController();
    // idController.text = Provider.of<AuthProvider>(context, listen: false).getUserEmail();
    // passwordController.text = Provider.of<AuthProvider>(context, listen: false).getUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCB800),
      body: AutofillGroup(
        child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: SizeConfig.screenHeight),
                      child: Container(
                        color: AppColors.primaryColorLight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: SizeConfig.blockSizeVertical * 6),

                            SizedBox(height: SizeConfig.blockSizeVertical * 1),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    'Sign In',
                                    style: headline4.copyWith(color: Colors.white, fontSize: 18),
                                    textAlign: TextAlign.left,
                                  ),
                                )),

                            //image container
                            Container(
                              height: SizeConfig.blockSizeVertical * 43,
                              padding: const EdgeInsets.all(8),
                              child: CarouselSlider.builder(
                                  itemCount: 2,
                                  options: CarouselOptions(
                                      aspectRatio: 1 / 1,
                                      viewportFraction: 1,
                                      autoPlay: true,
                                      autoPlayInterval: const Duration(seconds: 10),
                                      initialPage: 1),
                                  itemBuilder: (context, index, realIndex) {
                                    return Image.asset(banners[index], fit: BoxFit.fill);
                                  }),
                            ),
                            //login bottom sheet
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 10),
                                margin: const EdgeInsets.only(left: 6, right: 6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                                    CustomTextField(
                                        hintText: 'Write Id',
                                        controller: idController,
                                        isShowBorder: true,
                                        verticalSize: 14,
                                        labelText: 'Student ID',
                                        focusNode: idFocus,
                                        nextFocus: passwordFocus,
                                        inputType: TextInputType.number,
                                        autoFillHints: AutofillHints.telephoneNumber),

                                    //username
                                    SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                    //password
                                    CustomTextField(
                                      hintText: 'Password',
                                      controller: passwordController,
                                      isPassword: true,
                                      isShowBorder: true,
                                      isShowSuffixIcon: true,
                                      labelText: 'Password',
                                      focusNode: passwordFocus,
                                      inputAction: TextInputAction.done,
                                      autoFillHints: AutofillHints.password,
                                      isSaveAutoFillData: true,
                                    ),
                                    SizedBox(height: SizeConfig.blockSizeVertical * 2),

                                    !authProvider.isLoading
                                        ? Column(
                                            children: [
                                              //forget Password
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        authProvider.toggleRememberMe();
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: authProvider.isActiveRememberMe ? AppColors.primaryColorLight : Colors.transparent,
                                                                border: Border.all(
                                                                    color: !authProvider.isActiveRememberMe ? AppColors.grey : Colors.transparent)),
                                                            child: const Icon(Icons.done, size: 15, color: AppColors.whiteColorDark),
                                                          ),
                                                          SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                                                          Text('Remember me', style: headline4.copyWith(fontSize: 12)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                              //SignIn
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: RoundedButton(
                                                      onPress: () {
                                                        authProvider.signIn(idController.text, passwordController.text).then((value) {
                                                          if (value == true) {
                                                            if (authProvider.studentModel1.role == 1) {
                                                              Navigator.of(context)
                                                                  .pushReplacement(MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
                                                            } else if (authProvider.studentModel1.role == 2) {
                                                              authProvider.changeUserStatus(2);
                                                              authProvider.getUserInfo();
                                                              Navigator.of(context)
                                                                  .pushReplacement(MaterialPageRoute(builder: (_) =>  LibraryScreen(isFromAdmin: true)));
                                                            } else if (authProvider.studentModel1.role == 3) {
                                                              authProvider.changeUserStatus(3);
                                                              authProvider.getUserInfo();
                                                              Navigator.of(context)
                                                                  .pushReplacement(MaterialPageRoute(builder: (_) =>  MedicalHomeScreen(true)));
                                                            } else {
                                                              authProvider.getUserInfo();
                                                              Navigator.of(context)
                                                                  .pushReplacement(MaterialPageRoute(builder: (_) => const StudentDashboardScreen()));
                                                            }
                                                          } else {}
                                                        });

                                                        // authProvider
                                                        //     .checkAdmin(
                                                        //         idController.text, passwordController.text, authProvider.isActiveRememberMe)
                                                        //     .then((value) {
                                                        //   if (value) {
                                                        //     Navigator.of(context).pushReplacement(
                                                        //         MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
                                                        //   } else {
                                                        //     authProvider
                                                        //         .checkStudent(idController.text, passwordController.text)
                                                        //         .then((studentLoginStatus) {
                                                        //       if (studentLoginStatus) {
                                                        //         Navigator.of(context).pushReplacement(
                                                        //             MaterialPageRoute(builder: (_) => const UserDashboardScreen()));
                                                        //       } else {
                                                        //         showMessage('Could not login! please check student id and password');
                                                        //       }
                                                        //     });
                                                        //   }
                                                        // });
                                                      },
                                                      boarderRadius: 8,
                                                      backgroundColor: MaterialStateProperty.all(Colors.black),
                                                      child: const AutoSizeText(
                                                        'Sign In',
                                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical * 2),

                                              TextButton(
                                                  onPressed: () {
                                                    Helper.toScreen(SignupScreen());
                                                  },
                                                  child: Text('Create a new Account'))

                                              //sign in with google
                                            ],
                                          )
                                        : const CustomLoader(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
