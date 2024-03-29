import 'package:duetstahall/data/model/response/student_summery_model.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/library/check_card_screen.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllStudentScreen extends StatefulWidget {
  const AllStudentScreen({Key? key}) : super(key: key);

  @override
  State<AllStudentScreen> createState() => _AllStudentScreenState();
}

class _AllStudentScreenState extends State<AllStudentScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<StudentProvider>(context, listen: false).callForGetUserAllStudent();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<StudentProvider>(context, listen: false).hasNextData) {
        Provider.of<StudentProvider>(context, listen: false).updateAllStudent();
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<StudentProvider>(context, listen: false).callForGetUserAllStudent(isFirstTime: false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColorDark,
        appBar: const CustomAppBar(title: "All Student"),
        body: Consumer2<StudentProvider, LibraryProvider>(
          builder: (context, studentProvider, libraryProvider, child) => studentProvider.isLoading || libraryProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  children: [
                    ListView.builder(
                        itemCount: studentProvider.studentSummeryList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          StudentSummeryModel s = studentProvider.studentSummeryList[index];
                          return Card(
                            child: ListTile(
                              onTap: () {
                                libraryProvider.deleteAllCard().then((value) {
                                  if (value == true) {
                                    Helper.toScreen(CheckCardScreen(isFromAllStudent: true, studentID: s.studentID.toString()));
                                  }
                                });
                              },
                              title: Text('${s.name}', style: robotoStyle600SemiBold),
                              subtitle: Text('${s.studentID}', style: robotoStyle600SemiBold),
                              trailing: Text('${s.department}', style: robotoStyle600SemiBold),
                            ),
                          );
                        }),
                    studentProvider.isBottomLoading
                        ? const Center(child: CircularProgressIndicator())
                        : studentProvider.hasNextData
                            ? InkWell(
                                onTap: () {
                                  studentProvider.updateUserTransactionListNo();
                                },
                                child: Container(
                                  height: 30,
                                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(border: Border.all(color: colorText), borderRadius: BorderRadius.circular(22)),
                                  child: Text('Load more Data', style: robotoStyle500Medium.copyWith(color: colorText)),
                                ),
                              )
                            : const SizedBox.shrink(),
                  ],
                ),
        ),
      ),
    );
  }
}
