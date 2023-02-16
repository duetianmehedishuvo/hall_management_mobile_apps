import 'package:duetstahall/dining/check_today_screen.dart';
import 'package:duetstahall/dining/create_user_screen.dart';
import 'package:duetstahall/dining/meal_rate_screen.dart';
import 'package:duetstahall/dining/student_screen.dart';
import 'package:duetstahall/dining/total_money.dart';
import 'package:duetstahall/dining/widgets/animated_custom_dialog.dart';
import 'package:duetstahall/dining/widgets/custom_button.dart';
import 'package:duetstahall/dining/widgets/guest_dialog.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<StudentProvider>(context, listen: false).initializeAllStudent();
    Provider.of<StudentProvider>(context, listen: false).getData();
    return WillPopScope(
      onWillPop: () {
        showAnimatedDialog(context, const GuestDialog(isLogin: true), isFlip: false);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Admin Dashboard')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            adminDashboardWidget(context, 'Add Student', const CreateUserScreen(), Icons.add),
            adminDashboardWidget(context, 'Modify Student', const StudentScreen(), Icons.edit),
            adminDashboardWidget(context, 'Delete Student', const StudentScreen(isDelete: true), Icons.delete),
            adminDashboardWidget(context, 'Add Student Meal Quantity', const StudentScreen(isUpdateMealCount: true), Icons.edit_attributes),
            adminDashboardWidget(context, 'Check Today Meal', const CheckTodayScreen(), Icons.fact_check),
            adminDashboardWidget(context, 'Check Tomorrow Meal', const CheckTodayScreen(isToday: false), Icons.fact_check),
            adminDashboardWidget(context, 'Meal Rate', MealRateScreen(), Icons.price_change),
            adminDashboardWidget(context, 'Current Money', const TotalMoneyScreen(), Icons.price_check),
            CustomButton(
                btnTxt: 'Sign Out',
                onTap: () {
                  showAnimatedDialog(context, const GuestDialog(isLogin: false), isFlip: false);
                }),
          ],
        ),
      ),
    );
  }

  Widget adminDashboardWidget(BuildContext context, String title, Widget widget, IconData iconData) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => widget));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryColorLight,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: headline3.copyWith(fontSize: 14, color: AppColors.whiteColorDark)),
            Icon(iconData, color: AppColors.whiteColorDark)
          ],
        ),
      ),
    );
  }
}
