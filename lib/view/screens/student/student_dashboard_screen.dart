import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/room_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/image.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/roomStudent/room_student_firstscreen.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Student Panel'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColorLight,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings))],
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
                  menuWidget(ImagesModel.newRoom, 'Room/Student History', RoomStudentFirstScreen()),
                  const SizedBox(width: 10),
                  menuWidget(ImagesModel.newCookingIcons, 'Meal', Container(), imageHeight: 86, secondHeight: 15),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget menuWidget(String imageUrl, String title, Widget nextWidget,
      {double firstHeight = 10, double secondHeight = 10, double thirdHeight = 10, double imageHeight = 80}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Helper.toScreen(nextWidget);
          Provider.of<RoomProvider>(context, listen: false).changeFloors(1);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
              ],
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
}
