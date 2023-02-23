import 'package:duetstahall/dining/my_meal_screen.dart';
import 'package:duetstahall/dining/user_dashboard.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/room_provider.dart';
import 'package:duetstahall/provider/settings_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/auth/signin_screen.dart';
import 'package:duetstahall/view/screens/payment/add_balance_screen.dart';
import 'package:duetstahall/view/screens/student/roomStudent/room_student_firstscreen.dart';
import 'package:duetstahall/view/screens/student/students/my_profile_screen.dart';
import 'package:duetstahall/view/screens/student/transaction/transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
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
        title: const Text('Student Panel'),
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
                  children: <Widget>[
                    Text("Welcome, ${authProvider.name}", style: headline4.copyWith(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 5),
                    Text('Current Balance:  ${authProvider.balance}',
                        style: headline5.copyWith(color: AppColors.whiteColorDark.withOpacity(.8))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  menuWidget(ImagesModel.newRoom, 'Room/Student History', const RoomStudentFirstScreen()),
                  const SizedBox(width: 10),
                  menuWidget(ImagesModel.newCookingIcons, 'Meal', MyMealScreen(), imageHeight: 86, secondHeight: 15),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  menuWidget(ImagesModel.newRoom, 'Balance', const AddBalanceScreen()),
                  const SizedBox(width: 10),
                  menuWidget(ImagesModel.newCookingIcons, 'Transaction', TransactionDetailsScreen(), imageHeight: 86, secondHeight: 15),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  menuWidget(ImagesModel.newRoom, 'Share Balance', const AddBalanceScreen(isShare: true)),
                  const SizedBox(width: 10),
                  menuWidget(ImagesModel.newCookingIcons, 'Transaction', Container(), imageHeight: 86, secondHeight: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget menuWidget(String imageUrl, String title, Widget nextWidget,
    {double firstHeight = 10, double secondHeight = 10, double thirdHeight = 10, double imageHeight = 80}) {
  return Expanded(
    child: InkWell(
      onTap: () {
        Helper.toScreen(nextWidget);
        Provider.of<RoomProvider>(Helper.navigatorKey.currentState!.context, listen: false).changeFloors(1);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            SizedBox(height: firstHeight),
            SvgPicture.asset(imageUrl, height: imageHeight),
            SizedBox(height: secondHeight),
            Text(title, style: headline4, textAlign: TextAlign.center)
          ],
        ),
      ),
    ),
  );
}
