import 'package:duetstahall/helper/open_call_url_map_sms_helper.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/provider/medical_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/auth/signin_screen.dart';
import 'package:duetstahall/view/screens/library/all_book_screen.dart';
import 'package:duetstahall/view/screens/library/check_card_screen.dart';
import 'package:duetstahall/view/screens/medical/all_medical_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class MedicalHomeScreen extends StatefulWidget {
  bool isFromAdmin;
   MedicalHomeScreen(this.isFromAdmin,{super.key});

  @override
  State<MedicalHomeScreen> createState() => _MedicalHomeScreenState();
}

class _MedicalHomeScreenState extends State<MedicalHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getUserInfo();
    Provider.of<MedicalProvider>(context, listen: false).changeLoadingFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFromAdmin ? 'Administration Medical Center' : 'Medical Center'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColorLight,
        actions: [
          !widget.isFromAdmin
              ? spaceZero
              : IconButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout().then((value) {
                      if (value == true) {
                        Helper.toRemoveUntilScreen(const LoginScreen());
                      }
                    });
                  },
                  icon: const Icon(Icons.logout)),
        ],
      ),
      body: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, child) => ModalProgressHUD(
          inAsyncCall: libraryProvider.isLoading,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              buttonWidget(Icons.design_services, 'All Medical Service', const ALlMedicalServiceScreen()),
              !widget.isFromAdmin ? spaceZero : buttonWidget(Icons.history, 'All History', AllBookScreen(isAdmin: true, isFromMedical: true)),
              widget.isFromAdmin ? spaceZero : buttonWidget(Icons.history, 'My History', AllBookScreen(isAdmin: false, isFromMedical: true)),
              !widget.isFromAdmin
                  ? spaceZero
                  : buttonWidget(Icons.add_circle, 'Add Patient New Entry', const AllBookScreen(isAdmin: true), onTap: () {
                      libraryProvider.deleteAllCard().then((value) {
                        if (value == true) {
                          Helper.toScreen(CheckCardScreen(isFromMedical: true));
                        }
                      });
                    }),

              buttonWidget(Icons.list, 'All Doctor Lists', Container(), url: 'https://www.duet.ac.bd/office/medical-center/employee-information'),
              buttonWidget(Icons.list_alt, 'All Employee Lists', Container(), url: 'https://www.duet.ac.bd/office/medical-center/employee-information'),
              // spaceHeight10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'DUET Medical Centre is placed in the ground floor of Library building which is situated in the Middle of this well-looking natural green University Campus. Where they provide efficient health care services for all the DUETIANS (Students, Teachers, Officers, Employees & Others) 24/7. They have a proficient health care team along with our 04 doctors, 02 Nurses, Senior Pharmaceutical Officer, Technical Officer (Lab), Assistant Technical Officer (Lab), Assistant Technical Officer (Pharmacy), Junior Store Officer (Medical store) and a compounder. They provide better health care services in this 09 roomed medical center and even residential services in case of medical emergencies. DUET Medical Centre also provide pathological services which includes more than 40 essential tests.',
                  style: robotoStyle400Regular.copyWith(fontSize: 13),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonWidget(IconData iconData, String title, Widget widget, {String? url, Function? onTap}) {
    return InkWell(
      onTap: () {
        if (url == null && onTap == null) {
          Helper.toScreen(widget);
        } else if (onTap != null) {
          onTap();
        } else {
          openNewLink(url!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 0))],
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [Icon(iconData, color: colorPrimaryLight), spaceWeight5, Text(title, style: robotoStyle500Medium.copyWith(fontSize: 15))],
        ),
      ),
    );
  }
}
