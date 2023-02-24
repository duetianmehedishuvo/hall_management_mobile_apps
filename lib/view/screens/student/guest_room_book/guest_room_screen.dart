import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/guest_room_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/complain/add_complain_screen.dart';
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
                    Helper.toScreen(AddComplainScreen());
                  },
                  backgroundColor: colorPrimaryLight,
                  child: const Icon(Icons.add)),
          body: Consumer<GuestRoomProvider>(
            builder: (context, guestRoomProvider, child) => guestRoomProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: controller,
                    itemCount: guestRoomProvider.guestRoomLists.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Helper.toScreen(ComplainDetailsScreen(
                          //     complainModel: guestRoomProvider.allComplainList[index], index: index, isAdmin: widget.isAdmin));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10), boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                          ]),
                          child: Text(guestRoomProvider.guestRoomLists[index].studentID!,
                              style: robotoStyle400Regular.copyWith(fontSize: 15, color: Colors.white)),
                        ),
                      );
                    },
                  ),
          )),
    );
  }
}
