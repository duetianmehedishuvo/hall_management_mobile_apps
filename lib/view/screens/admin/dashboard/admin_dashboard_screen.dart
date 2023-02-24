import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/settings_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/admin/hall_fee/hall_fee_admin_screen.dart';
import 'package:duetstahall/view/screens/admin/settings/settings_screen.dart';
import 'package:duetstahall/view/screens/auth/signin_screen.dart';
import 'package:duetstahall/view/screens/student/roomStudent/room_student_firstscreen.dart';
import 'package:duetstahall/view/screens/student/student_dashboard_screen.dart';
import 'package:duetstahall/view/screens/student/students/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<SettingsProvider>(context, listen: false).configModel.mealRate == null ||
        Provider.of<SettingsProvider>(context, listen: false).configModel.mealRate!.isEmpty) {
      Provider.of<SettingsProvider>(context, listen: false).getConfigData();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Administrator Panel'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColorLight,
        actions: [
          IconButton(
              onPressed: () {
                Helper.toScreen(MyProfileScreen(Provider.of<AuthProvider>(context, listen: false).studentID));
              },
              icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout().then((value) {
                  if (value == true) {
                    Helper.toRemoveUntilScreen(const LoginScreen());
                  }
                });
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: const BoxDecoration(
                  color: AppColors.primaryColorLight,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome, ${authProvider.name}", style: headline4.copyWith(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  menuWidget(ImagesModel.newRoom, 'Room', const RoomStudentFirstScreen()),
                  const SizedBox(width: 10),
                  menuWidget(ImagesModel.newCookingIcons, 'Meal', Container()),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  menuWidget(ImagesModel.newRoom, 'Settings', SettingsScreen()),
                  const SizedBox(width: 10),
                  menuWidget(ImagesModel.newCookingIcons, 'Hall Fee', HallFeeAdminScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
