import 'package:duetstahall/data/model/response/room_model.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_loader.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({Key? key}) : super(key: key);

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  late TextEditingController roomIDController;
  late TextEditingController yearController;
  late TextEditingController floorIDController;
  FocusNode roomIDFocus = FocusNode();
  FocusNode yearFocus = FocusNode();
  FocusNode floorIDFocus = FocusNode();
  FocusNode student1Focus = FocusNode();
  FocusNode student2Focus = FocusNode();
  FocusNode student3Focus = FocusNode();
  FocusNode student4Focus = FocusNode();
  FocusNode student5Focus = FocusNode();
  FocusNode student6Focus = FocusNode();
  FocusNode studentExtraFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomIDController = TextEditingController();
    yearController = TextEditingController();
    floorIDController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColorDark,
      appBar: const CustomAppBar(title: "Create Room Database"),
      body: AutofillGroup(
        child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        CustomTextField(
                          hintText: 'Room ID',
                          labelText: 'Write Room ID:',
                          isShowBorder: true,
                          controller: roomIDController,
                          verticalSize: 14,
                          focusNode: roomIDFocus,
                          nextFocus: yearFocus,
                          inputType: TextInputType.number,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        CustomTextField(
                            hintText: 'Year',
                            labelText: 'Write Year:',
                            inputType: TextInputType.number,
                            isShowBorder: true,
                            focusNode: yearFocus,
                            nextFocus: floorIDFocus,
                            controller: yearController,
                            verticalSize: 14),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        CustomTextField(
                          isShowBorder: true,
                          hintText: 'Floor',
                          labelText: 'Write Floor NO:',
                          controller: floorIDController,
                          verticalSize: 14,
                          focusNode: floorIDFocus,
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.done,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        suggestionTextField(authProvider, 0),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        suggestionTextField(authProvider, 1),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        suggestionTextField(authProvider, 2),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        suggestionTextField(authProvider, 3),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        suggestionTextField(authProvider, 4),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        suggestionTextField(authProvider, 5),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        suggestionTextField(authProvider, 6),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        !authProvider.isLoading
                            ? CustomButton(
                                onTap: () {
                                  if (roomIDController.text.isEmpty || yearController.text.isEmpty || floorIDController.text.isEmpty) {
                                    showMessage('please fill up all fields');
                                  } else {
                                    // int totalStudents = 0;
                                    // if (authProvider.selectStudent1.isNotEmpty) totalStudents += 1;
                                    // if (authProvider.selectStudent2.isNotEmpty) totalStudents += 1;
                                    // if (authProvider.selectStudent3.isNotEmpty) totalStudents += 1;
                                    // if (authProvider.selectStudent4.isNotEmpty) totalStudents += 1;
                                    // if (authProvider.selectStudent5.isNotEmpty) totalStudents += 1;
                                    // if (authProvider.selectStudent6.isNotEmpty) totalStudents += 1;
                                    // if (authProvider.selectStudentExtra.isNotEmpty) totalStudents += 1;
                                    //
                                    // RoomModel roomModel = RoomModel(
                                    //     floor: int.parse(floorIDController.text),
                                    //     roomID: int.parse(roomIDController.text),
                                    //     year: int.parse(yearController.text),
                                    //     student1: authProvider.selectStudent1,
                                    //     student2: authProvider.selectStudent2,
                                    //     student3: authProvider.selectStudent3,
                                    //     student4: authProvider.selectStudent4,
                                    //     student5: authProvider.selectStudent5,
                                    //     student6: authProvider.selectStudent6,
                                    //     studentExtra: authProvider.selectStudentExtra,
                                    //     totalStudents: totalStudents);
                                    //
                                    // authProvider.addRooms(roomModel);
                                    // authProvider.resetStudents();
                                  }
                                },
                                btnTxt: "Submit",
                              )
                            : const CustomLoader(),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }

  Widget suggestionTextField(AuthProvider authProvider, int position) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) async {
        if (value.text.isEmpty) {
          return List.empty();
        }
        // List<String> data = await authProvider.getSuggestionsData(value.text);
        // return data.where((element) => element.toLowerCase().contains(value.text.toLowerCase())).toList();
        return List.empty();
      },
      fieldViewBuilder: (BuildContext context, TextEditingController controller, FocusNode node, Function onSubmit) => CustomTextField(
        controller: controller,
        focusNode: node,
        labelText:
            '${position == 0 ? "First" : position == 1 ? "Second" : position == 2 ? "Third" : position == 3 ? "Fourth" : position == 4 ? "Fifth" : position == 5 ? "Sixth" : "Extra"} Student ID:',
        hintText:
            'Type here ${position == 0 ? "First" : position == 1 ? "Second" : position == 2 ? "Third" : position == 3 ? "Fourth" : position == 4 ? "Fifth" : position == 5 ? "Sixth" : "Extra"} Student ID... ',
        isShowBorder: true,
        verticalSize: 14,
        inputType: TextInputType.number,
        inputAction: TextInputAction.done,
      ),
      optionsViewBuilder: (BuildContext context, Function onSelect, Iterable<String> dataList) {
        return Material(
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              String d = dataList.elementAt(index);
              return InkWell(onTap: () => onSelect(d), child: ListTile(title: Text(d)));
            },
          ),
        );
      },
      onSelected: (value) {
        // authProvider.changeValue(value, position);
      },
      displayStringForOption: (String d) => d,
    );
  }
}
