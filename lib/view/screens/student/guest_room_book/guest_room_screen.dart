import 'package:duetstahall/data/model/response/guest_room_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/guest_room_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/guest_room_book/add_guest_room_screen.dart';
import 'package:duetstahall/view/screens/student/guest_room_book/guest_room_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuestRoomScreen extends StatefulWidget {
  final bool isAdmin;

  const GuestRoomScreen({this.isAdmin = false, Key? key}) : super(key: key);

  @override
  State<GuestRoomScreen> createState() => _GuestRoomScreenState();
}

class _GuestRoomScreenState extends State<GuestRoomScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GuestRoomProvider>(context, listen: false).getAllRoomAssign(isAdmin: true);
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<GuestRoomProvider>(context, listen: false).hasNextData) {
        Provider.of<GuestRoomProvider>(context, listen: false).updateAllGuestRoomAssign(isAdmin: true);
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<GuestRoomProvider>(context, listen: false).getAllRoomAssign(isFirstTime: false, isAdmin: true);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Guest Room Book', borderRadius: 0),
          floatingActionButton: widget.isAdmin
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  onPressed: () {
                    Provider.of<GuestRoomProvider>(context, listen: false).resetDateTime();
                    Helper.toScreen(AddGuestRoomScreen());
                  },
                  backgroundColor: colorPrimaryLight,
                  child: const Icon(Icons.add, color: Colors.white)),
          body: Consumer<GuestRoomProvider>(
            builder: (context, guestRoomProvider, child) => guestRoomProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const CircleAvatar(backgroundColor: Colors.green, radius: 10),
                                  Text('  Accepted', style: robotoStyle600SemiBold)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [const CircleAvatar(backgroundColor: Colors.grey, radius: 10), Text('  Queue', style: robotoStyle600SemiBold)],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount: guestRoomProvider.guestRoomLists.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          itemBuilder: (context, index) {
                            GuestRoomModel g = guestRoomProvider.guestRoomLists[index];
                            return InkWell(
                              onTap: () {
                                guestRoomProvider.changeGuestRoom(g);
                                Helper.toScreen(GuestRoomDetailsScreen(guestRoomModel: g, index: index, isAdmin: widget.isAdmin));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                margin: const EdgeInsets.only(bottom: 10),
                                width: screenWeight(),
                                decoration: BoxDecoration(
                                    color: g.status == 0 ? Colors.grey : Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${DateConverter.localDate(g.date!)} | ${guestRoomProvider.roomType[g.roomNO! as int]} | ${g.studentID!}',
                                        style: robotoStyle400Regular.copyWith(fontSize: 15, color: Colors.white), textAlign: TextAlign.justify),
                                    Text('${DateConverter.localTime(g.startTime!)} - ${DateConverter.localTime(g.endTime!)}',
                                        style: robotoStyle400Regular.copyWith(fontSize: 15, color: Colors.white), textAlign: TextAlign.justify),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }
}
