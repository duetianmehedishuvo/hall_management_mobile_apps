import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';

class ALlMedicalServiceScreen extends StatelessWidget {
  const ALlMedicalServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Medical Service'),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "⚈ General OPD (Outpatient Department) Services: This likely includes consultations with a general physician for common illnesses and injuries.",
              style: robotoStyle600SemiBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "⚈ Pathology Services: They mention offering more than 40 essential tests, which could include blood tests, urine tests, and other diagnostic tests.",
              style: robotoStyle600SemiBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "⚈ Emergency care: Their website states they provide residential services in case of medical emergencies, although the extent of emergency care they can provide is unclear.",
              style: robotoStyle600SemiBold,
            ),
          ),
          spaceHeight10,
          Text(
            "It's likely Duet Medical Center Gazipur offers additional services beyond this list.  We recommend calling them at +88-02-49274003 for a more definitive answer.",
            style: robotoStyle600SemiBold,
          ),
        ],
      ),
    );
  }
}
