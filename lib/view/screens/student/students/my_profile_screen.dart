import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  final String studentID;

  const MyProfileScreen(this.studentID, {Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<StudentProvider>(context, listen: false).getStudentInfoByID(widget.studentID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'My Profile'),
        body: Consumer<StudentProvider>(
          builder: (context, studentProvider, child) => studentProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        InkWell(
                            onTap: () {
                              Provider.of<AuthProvider>(context, listen: false).initializeBloodAndDepartments(
                                  studentProvider.studentModel1.bloodGroup!, studentProvider.studentModel1.department!);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => SignupScreen(isDetails: true, studentModel: studentProvider.studentModel1)));
                            },
                            child: profileButton('Update Info')),
                        const SizedBox(width: 10),
                        profileButton('Change Password'),
                        const SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text('Your Public Details Information:', style: robotoStyle500Medium.copyWith(fontSize: 15)),
                    ),
                    const Divider(),
                    studentDetailsView(studentProvider),
                  ],
                ),
        ));
  }

  Widget profileButton(String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: colorPrimaryLight, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(3)),
        child: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(15)),
          child: Text(title, style: robotoStyle500Medium.copyWith(color: colorPrimaryLight)),
        ),
      ),
    );
  }
}

Widget studentDetailsView(StudentProvider studentProvider) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(capitalize(studentProvider.studentModel1.name!), style: robotoStyle600SemiBold.copyWith(fontSize: 17)),
        Text(capitalize(studentProvider.studentModel1.jobPosition!.isEmpty ? "Student" : studentProvider.studentModel1.jobPosition!),
            style: latoStyle500Medium.copyWith(fontSize: 17)),
        const SizedBox(height: 4),
        Text('Department of ${studentProvider.studentModel1.department}', style: latoStyle400Regular.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              innerTabWidget(studentProvider, studentProvider.isSelectBasicInfo, true, 'Basic Info'),
              const SizedBox(width: 10),
              innerTabWidget(studentProvider, !studentProvider.isSelectBasicInfo, false, 'Other Info'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        studentProvider.isSelectBasicInfo
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  singleItemWithKeyValue("Student-ID:", studentProvider.studentModel1.studentID!.toString()),
                  const Divider(),
                  singleItemWithKeyValue("Hometown:", capitalize(studentProvider.studentModel1.homeTown!)),
                  const Divider(),
                  singleItemWithKeyValue("Blood Group:", capitalize(studentProvider.studentModel1.bloodGroup!)),
                  const Divider(),
                  singleItemWithKeyValueAndCopy("Phone No:", studentProvider.studentModel1.phoneNumber!.toString()),
                  const Divider(),
                  singleItemWithKeyValueAndCopy("Email:", studentProvider.studentModel1.email!.toString()),
                  const Divider(),
                  singleItemWithKeyValueAndCopy("WhatsApp:", studentProvider.studentModel1.whatssApp!.toString()),
                  const Divider(),
                  Text('Details:', style: robotoStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(studentProvider.studentModel1.details!, style: robotoStyle400Regular.copyWith(fontSize: 16)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thesis Topics:', style: robotoStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                  const SizedBox(height: 5),
                  studentProvider.studentModel1.researchArea!.isEmpty
                      ? noDataAvailable()
                      : Text(studentProvider.studentModel1.researchArea!, style: robotoStyle400Regular.copyWith(fontSize: 16)),
                  const Divider(),
                  Text('Future Goal:', style: robotoStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                  const SizedBox(height: 5),
                  studentProvider.studentModel1.futureGoal!.isEmpty
                      ? noDataAvailable()
                      : Text(studentProvider.studentModel1.futureGoal!, style: robotoStyle400Regular.copyWith(fontSize: 16)),
                  const Divider(),
                  Text('Motive:', style: robotoStyle600SemiBold.copyWith(color: Colors.black, fontSize: 16)),
                  const SizedBox(height: 5),
                  studentProvider.studentModel1.motive!.isEmpty
                      ? noDataAvailable()
                      : Text(studentProvider.studentModel1.motive!, style: robotoStyle400Regular.copyWith(fontSize: 16)),
                  const Divider(),
                ],
              )
      ],
    ),
  );
}

Widget innerTabWidget(StudentProvider studentProvider, bool isSelect, bool status, String title) {
  return Expanded(
      child: InkWell(
    onTap: () {
      studentProvider.changeBasicInfo(status);
    },
    child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
            color: isSelect == true ? colorPrimaryLight : AppColors.imageBGColorDark,
            borderRadius: BorderRadius.circular(isSelect == true ? 10 : 4)),
        child: Text(title, style: robotoStyle500Medium.copyWith(color: isSelect == true ? Colors.white : Colors.black))),
  ));
}
