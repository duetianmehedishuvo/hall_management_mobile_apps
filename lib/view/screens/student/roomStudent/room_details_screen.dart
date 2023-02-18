import 'package:duetstahall/data/model/response/room_model1.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/room_provider.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/cupertino.dart';
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
          builder: (context, roomProvider, child) => ListView(
            padding: const EdgeInsets.all(15),
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(.04), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Running Students List:', style: robotoStyle900Black.copyWith(fontSize: 16, color: Colors.black)),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: roomProvider.activeStudents.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    RoomModel1 roomModel = roomProvider.activeStudents[index];

                    return studentInfoWidget(roomModel);
                  }),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(.04), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Previous Students List:', style: robotoStyle900Black.copyWith(fontSize: 16, color: Colors.black)),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: roomProvider.inactiveStudents.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    RoomModel1 roomModel = roomProvider.inactiveStudents[index];

                    return studentInfoWidget(roomModel);
                  }),
            ],
          ),
        ));
  }

  Widget studentInfoWidget(RoomModel1 roomModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3, top: 3),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.09), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          singleItem('S-ID:', roomModel.studentID.toString()),
          singleItem('Name:', roomModel.name.toString()),
          singleItem('Department:', roomModel.department.toString()),
          singleItem('Joining Date:', roomModel.updatedAt.toString()),
          // Divider()
        ],
      ),
    );
  }

  Widget singleItem(String key, String value) {
    return Row(
      children: [
        Text(key, style: robotoStyle600SemiBold.copyWith(color: Colors.black,fontSize: 15)),
        const SizedBox(width: 5),
        Expanded(child: Text(value, style: robotoStyle400Regular.copyWith(fontSize: 16))),
      ],
    );
  }
}
