import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentDetailsScreen extends StatefulWidget {
  final String studentID;

  const StudentDetailsScreen(this.studentID, {Key? key}) : super(key: key);

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
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
        appBar: const CustomAppBar(title: 'Student Details'),
        body: Consumer<StudentProvider>(
          builder: (context, studentProvider, child) =>
              studentProvider.isLoading ? const Center(child: CircularProgressIndicator()) : studentDetailsView(studentProvider),
        ));
  }
}

Widget studentDetailsView(StudentProvider studentProvider) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(capitalize(studentProvider.studentModel1.name!), style: robotoStyle600SemiBold.copyWith(fontSize: 17)),
        Text(capitalize(studentProvider.studentModel1.jobPosition!.isEmpty ? "Student" : studentProvider.studentModel1.jobPosition!),
            style: latoStyle500Medium.copyWith(fontSize: 17)),
        Text('Department of ${studentProvider.studentModel1.department}', style: latoStyle400Regular.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        Row(
          children: [
            innerTabWidget(studentProvider, studentProvider.isSelectBasicInfo, true),
            const SizedBox(width: 10),
            innerTabWidget(studentProvider, !studentProvider.isSelectBasicInfo, false),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              studentProvider.isSelectBasicInfo
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        singleItemWithKeyValue("Student-ID:", studentProvider.studentModel1.studentID!.toString()),
                        const Divider(),
                        singleItemWithKeyValue("Hometown:", capitalize(studentProvider.studentModel1.homeTown!)),
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
        )
      ],
    ),
  );
}

Widget innerTabWidget(StudentProvider studentProvider, bool isSelect, bool status) {
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
        child: Text('Basic Info', style: robotoStyle500Medium.copyWith(color: isSelect == true ? Colors.white : Colors.black))),
  ));
}
