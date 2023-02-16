import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_button.dart';
import 'package:duetstahall/dining/widgets/custome_text_fields.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/app_constant.dart';

class MealRateScreen extends StatelessWidget {
  MealRateScreen({Key? key}) : super(key: key);
  final TextEditingController mealRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Meal Rate'),
      body: StreamBuilder<QuerySnapshot>(
          stream: mealRateCollection.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  var docSnap = snapshot.data!.docs;
                  return Column(children: [
                    const SizedBox(height: 20),
                    Text('Current Meal Rate : ${docSnap[0]['meal-rate']}৳', style: headline4.copyWith()),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 200,
                      child: CustomTextField(
                        labelText: 'New Meal Rate',
                        hintText: 'Quantity',
                        isShowBorder: true,
                        controller: mealRateController,
                        inputType: TextInputType.number,
                        inputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: 200,
                        child: CustomButton(
                            btnTxt: 'Submit',
                            onTap: () {
                              if (mealRateController.text.isEmpty) {
                                showMessage('New Meal Rate Field is Required');
                              } else {
                                Provider.of<StudentProvider>(context, listen: false).addMealRate(int.parse(mealRateController.text));
                              }
                            },
                            radius: 10))
                  ]);
                });
          }),
    );
  }
}
