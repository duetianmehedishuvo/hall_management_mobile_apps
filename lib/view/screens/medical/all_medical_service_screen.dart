import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:flutter/material.dart';

class ALlMedicalServiceScreen extends StatelessWidget {
  const ALlMedicalServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Medical Service'),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [Image.asset('assets/images/medical_image.png',fit: BoxFit.fill,height: 350,width: screenWeight(),)],
      ),
    );
  }
}
