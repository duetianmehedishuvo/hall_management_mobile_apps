import 'package:duetstahall/data/model/response/room_model1.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/room_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/students/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({Key? key}) : super(key: key);

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'R${Provider.of<RoomProvider>(context, listen: false).selectedRooms} Details Information'),
        body: Consumer<RoomProvider>(
          builder: (context, roomProvider, child) => roomProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(15),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.04), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Running Students List:', style: robotoStyle900Black.copyWith(fontSize: 16, color: Colors.black)),
                        ],
                      ),
                    ),
                    roomProvider.activeStudents.isNotEmpty
                        ? ListView.builder(
                            itemCount: roomProvider.activeStudents.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              RoomModel1 roomModel = roomProvider.activeStudents[index];

                              return studentInfoWidget(roomModel, roomProvider, index);
                            })
                        : noDataAvailable(),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.04), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Previous Students List:', style: robotoStyle900Black.copyWith(fontSize: 16, color: Colors.black)),
                        ],
                      ),
                    ),
                    roomProvider.inactiveStudents.isNotEmpty
                        ? ListView.builder(
                            itemCount: roomProvider.inactiveStudents.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              RoomModel1 roomModel = roomProvider.inactiveStudents[index];

                              return studentInfoWidget(roomModel, roomProvider, index);
                            })
                        : noDataAvailable(),
                  ],
                ),
        ));
  }

  Widget studentInfoWidget(RoomModel1 roomModel, RoomProvider roomProvider, int index) {
    return InkWell(
      onTap: () {
        roomProvider.changeRoomAccess(roomModel.isAvaible == 0 ? false : true, isFirstTime: true);
        roomProvider.userTempData(roomModel.id.toString(), index, roomModel.studentID.toString());
        bool isAdmin = Provider.of<AuthProvider>(context, listen: false).userStatus == 1 ? true : false;
        Helper.toScreen(StudentDetailsScreen(roomModel.studentID.toString(), isFromRoomAndAdmin: isAdmin));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 3, top: 3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(.09), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            singleItemWithKeyValue('S-ID:', roomModel.studentID.toString()),
            singleItemWithKeyValue('Name:', roomModel.name.toString()),
            singleItemWithKeyValue('Department:', roomModel.department.toString()),
            singleItemWithKeyValue('Joining Date:', roomModel.updatedAt.toString()),
            // Divider()
          ],
        ),
      ),
    );
  }
}
