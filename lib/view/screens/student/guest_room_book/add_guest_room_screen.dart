import 'package:duetstahall/data/model/response/guest_room_model.dart';
import 'package:duetstahall/helper/date_and_time_picker.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/guest_room_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class AddGuestRoomScreen extends StatefulWidget {
  final GuestRoomModel? guestRoomModel;
  final bool isEdit;

  const AddGuestRoomScreen({this.guestRoomModel, this.isEdit = false, super.key});

  @override
  State<AddGuestRoomScreen> createState() => _AddGuestRoomScreenState();
}

class _AddGuestRoomScreenState extends State<AddGuestRoomScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isEdit) {
      phoneController.text = widget.guestRoomModel!.phoneNo!;
      purposeController.text = widget.guestRoomModel!.purpose!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "${widget.isEdit ? "Update" : "Add"} Guest Room"),
      body: AutofillGroup(
        child: Consumer<GuestRoomProvider>(
            builder: (context, guestRoomProvider, child) => ModalProgressHUD(
                  inAsyncCall: guestRoomProvider.isLoading,
                  progressIndicator: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColorLight)),
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: CupertinoColors.systemGrey), borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              selectedColor: AppColors.imageBGColorLight,
                              selectedTileColor: AppColors.imageBGColorLight,
                              splashColor: AppColors.imageBGColorLight,
                              tileColor: AppColors.imageBGColorLight,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Text("Room Type", style: robotoStyle500Medium),
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              trailing: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: false,
                                  value: guestRoomProvider.selectRoomType,
                                  focusColor: AppColors.imageBGColorLight,
                                  dropdownColor: AppColors.imageBGColorLight,
                                  items: guestRoomProvider.roomType.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: SizedBox(
                                          width: 150, //expand here
                                          child: Text(item, textAlign: TextAlign.end, style: robotoStyle600SemiBold)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    guestRoomProvider.changeRoomType(value.toString());
                                  },
                                  hint: const SizedBox(
                                    width: 150,
                                    child: Text("Select Item Type", style: TextStyle(color: Colors.grey), textAlign: TextAlign.end),
                                  ),
                                  style: const TextStyle(color: Colors.black, decorationColor: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                      btnTxt: 'Start Time',
                                      onTap: () async {
                                        DateTime? dateTime = await showDateTimePicker(context: context);
                                        guestRoomProvider.changeDateTime(true, dateTime!);
                                      })),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          guestRoomProvider.startTime != null
                                              ? DateConverter.localDateToIsoString2(guestRoomProvider.startTime!)
                                              : 'Time not selected',
                                          style: robotoStyle400Regular)))
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                      btnTxt: 'End Time',
                                      onTap: () async {
                                        DateTime? dateTime = await showDateTimePicker(context: context);
                                        print(dateTime);
                                        guestRoomProvider.changeDateTime(false, dateTime!);
                                      })),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          guestRoomProvider.endTime != null
                                              ? DateConverter.localDateToIsoString2(guestRoomProvider.endTime!)
                                              : 'Time not selected',
                                          style: robotoStyle400Regular)))
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                          CustomTextField(
                            hintText: 'Write Phone Number........',
                            isShowBorder: true,
                            controller: phoneController,
                            verticalSize: 14,
                            labelText: 'Enter Phone Number',
                            inputType: TextInputType.phone,
                            maxLines: 1,
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                          CustomTextField(
                            hintText: 'Write purpose....',
                            isShowBorder: true,
                            controller: purposeController,
                            verticalSize: 14,
                            maxLines: 5,
                            labelText: 'Enter your purpose',
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 15),
                          Text('NOTE: this is very important and sensitive so please add before carefully, thanks',
                              style: robotoStyle600SemiBold.copyWith(color: Colors.red), textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          CustomButton(
                              btnTxt: widget.isEdit ? "Update" : "Add",
                              onTap: () {
                                if (guestRoomProvider.startTime == null || guestRoomProvider.endTime == null) {
                                  showMessage('Please provide Start and End Time');
                                } else if (phoneController.text.isEmpty) {
                                  showMessage('Please provide your phone number');
                                } else if (phoneController.text.length != 11) {
                                  showMessage('Please provide valid phone number');
                                } else if (purposeController.text.isEmpty) {
                                  showMessage('Please Write Details here...');
                                } else {
                                  if (widget.isEdit) {
                                    // guestRoomProvider
                                    //     .editComplain(widget.complainModel!.id! as int, subjectController.text, complainController.text)
                                    //     .then((value) {
                                    //   if (value == true) {
                                    //     subjectController.clear();
                                    //     complainController.clear();
                                    //     Helper.back();
                                    //     Helper.back();
                                    //   }
                                    // });
                                  } else {
                                    guestRoomProvider.addGuestRoomBook(purposeController.text, phoneController.text).then((value) {
                                      if (value == true) {
                                        purposeController.clear();
                                        phoneController.clear();
                                        Helper.back();
                                      }
                                    });
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
