import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/app_constant.dart';

class TotalMoneyScreen extends StatelessWidget {
  const TotalMoneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Current Money'),
      body: StreamBuilder<QuerySnapshot>(
          stream: mealRateCollection.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text('Meal Rate : ${snapshot.data!.docs[0]['meal-rate']}৳', style: headline4.copyWith()),
                    const SizedBox(height: 20),
                    Text('Total Meal : ${Provider.of<StudentProvider>(context).totalStudentMeal} P', style: headline4.copyWith()),
                    const SizedBox(height: 50),
                    Text('Current Total Money : ${Provider.of<StudentProvider>(context).totalStudentMeal * snapshot.data!.docs[0]['meal-rate']}৳', style: headline4.copyWith()),
                  ]),
            );
          }),
    );
  }
}
