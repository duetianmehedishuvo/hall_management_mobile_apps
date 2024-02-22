import 'package:duetstahall/data/model/response/guest_room_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/guest_room_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuestRoomDetailsScreen extends StatefulWidget {
  final bool isAdmin;
  final int index;
  final GuestRoomModel guestRoomModel;

  const GuestRoomDetailsScreen({this.isAdmin = false, this.index = 0, required this.guestRoomModel, super.key});

  @override
  State<GuestRoomDetailsScreen> createState() => _GuestRoomDetailsScreenState();
}

class _GuestRoomDetailsScreenState extends State<GuestRoomDetailsScreen> {
  final TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'Guest Room Details', borderRadius: 10),
        body: Consumer<GuestRoomProvider>(
          builder: (context, guestRoomProvider, child) => guestRoomProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                        Text(DateConverter.localDate(widget.guestRoomModel.date!),
                            style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Time:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                        Text('${DateConverter.localTime(widget.guestRoomModel.startTime!)} - ${DateConverter.localTime(widget.guestRoomModel.endTime!)}',
                            style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                        Text(widget.guestRoomModel.status == 0 ? 'Queue' : 'Accepted',
                            style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Room:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                        Text(guestRoomProvider.roomType[widget.guestRoomModel.roomNO as int],
                            style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Phone:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                        Text('${widget.guestRoomModel.phoneNo}', style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                    const Divider(),
                    Text('Purpose:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(widget.guestRoomModel.purpose!, style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                    const Divider(),
                    widget.isAdmin || widget.guestRoomModel.studentID == Provider.of<AuthProvider>(context, listen: false).studentID
                        ? Column(
                            children: [
                              widget.isAdmin
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Room Status:', style: robotoStyle500Medium.copyWith(color: AppColors.primaryColorLight, fontSize: 17)),
                                        Switch(
                                            value: guestRoomProvider.hasAvailableRoom,
                                            activeColor: AppColors.primaryColorLight,
                                            onChanged: (value) {
                                              guestRoomProvider.changeGuestRoomAccess(value);
                                            })
                                      ],
                                    )
                                  : spaceZero,
                              widget.isAdmin || widget.guestRoomModel.status == 0
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 90,
                                            child: CustomButton(
                                                btnTxt: 'Delete',
                                                onTap: () {
                                                  guestRoomProvider.deleteGuestRoomBook().then((value) {
                                                    if (value = true) {
                                                      Helper.back();
                                                    }
                                                  });
                                                })),
                                      ],
                                    )
                                  : spaceZero,
                            ],
                          )
                        : spaceZero,
                    widget.isAdmin || widget.guestRoomModel.studentID == Provider.of<AuthProvider>(context, listen: false).studentID
                        ? const Divider()
                        : spaceZero,
                  ],
                ),
        ));
  }
}
