import 'package:duetstahall/dining/my_meal_screen.dart';
import 'package:duetstahall/dining/payment_screen.dart';
import 'package:duetstahall/dining/update_user_profile_screen.dart';
import 'package:duetstahall/dining/widgets/animated_custom_dialog.dart';
import 'package:duetstahall/dining/widgets/custom_button.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/dining/widgets/guest_dialog.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Provider.of<StudentProvider>(context, listen: false).initializeStudent(Provider.of<AuthProvider>(context, listen: false).getStudentID());
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), elevation: 0, centerTitle: true),
      body: Consumer<StudentProvider>(
        builder: (context, studentProvider, child) {
          return !studentProvider.isLoading
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          CustomButton(
                              btnTxt: 'My Meal',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyMealScreen()));
                              },
                              isStroked: false,
                              radius: 10),

                          const SizedBox(height: 15),
                          CustomButton(
                              btnTxt: 'Add Meal Balance',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentScreen()));
                              },
                              isStroked: false,
                              radius: 10),
                          const SizedBox(height: 15),
                          CustomButton(
                              btnTxt: 'Update Profile',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UpdateUserProfileScreen()));
                              },
                              isStroked: false,
                              radius: 10),
                          const SizedBox(height: 15),
                          CustomButton(
                              btnTxt: 'Logout',
                              onTap: () {
                                showAnimatedDialog(context, const GuestDialog(isLogin: false), isFlip: false);

                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (context) => const LoginScreen()),
                                //     (Route<dynamic> route) => false);
                              },
                              isStroked: false,
                              radius: 10),
                        ],
                      ),
                    )
                  ],
                )
              : const CustomLoader();
        },
      ),
    );
  }
}
