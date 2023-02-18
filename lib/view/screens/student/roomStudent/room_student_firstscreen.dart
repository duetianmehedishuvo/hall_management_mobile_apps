import 'dart:math';

import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomStudentFirstScreen extends StatefulWidget {
  const RoomStudentFirstScreen({Key? key}) : super(key: key);

  @override
  State<RoomStudentFirstScreen> createState() => _RoomStudentFirstScreenState();
}

class _RoomStudentFirstScreenState extends State<RoomStudentFirstScreen> {
  final List<Color> colorCollection = <Color>[];

  @override
  void initState() {
    super.initState();
    addColorToArray();
  }

  void addColorToArray() {
    //Here you can add color as your requirement and call it in initState
    colorCollection.add(AppColors.primaryColorLight);
    colorCollection.add(AppColors.primaryColorLight.withOpacity(.9));
    colorCollection.add(AppColors.primaryColorLight.withOpacity(.8));
    colorCollection.add(AppColors.primaryColorLight);
    colorCollection.add(AppColors.primaryColorLight.withOpacity(.9));
    colorCollection.add(AppColors.primaryColorLight.withOpacity(.8));
    colorCollection.add(AppColors.primaryColorLight);
    colorCollection.add(AppColors.primaryColorLight.withOpacity(.9));
    colorCollection.add(AppColors.primaryColorLight.withOpacity(.8));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Room/Student History'),
        body: Consumer<StudentProvider>(
          builder: (context, studentProvider, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          width: screenWeight() * 0.45,
                          child: CustomButton(
                            btnTxt: 'Search Student',
                            onTap: () {},
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(child: Text('----------------------------------------------', maxLines: 1)),
                    Text(' OR ', style: robotoStyle700Bold),
                    const Expanded(child: Text('----------------------------------------------', maxLines: 1)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 45,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(245, 246, 248, 1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: CupertinoColors.systemGrey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(child: Text('Select Floors: ', style: headline4)),
                            DropdownButton<int>(
                              items: studentProvider.floorsLists.map((dep) {
                                return DropdownMenuItem<int>(
                                    value: dep, child: Text(dep.toString(), style: headline4, textAlign: TextAlign.center));
                              }).toList(),
                              underline: const SizedBox.shrink(),
                              isExpanded: false,
                              value: studentProvider.selectedFloors,
                              onChanged: (value) async {
                                studentProvider.changeFloors(value!);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                        width: 70,
                        child: CustomButton(
                          btnTxt: 'GO',
                          onTap: () {
                            studentProvider.generateRooms();
                          },
                          radius: 100,
                        ))
                  ],
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView.builder(
                        itemCount: studentProvider.roomLists.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [colorCollection[Random().nextInt(9)], colorCollection[Random().nextInt(9)]]),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text('${studentProvider.roomLists[index]}',
                                    style: robotoStyle700Bold.copyWith(color: Colors.white, fontSize: 14))),
                          );
                        },
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
