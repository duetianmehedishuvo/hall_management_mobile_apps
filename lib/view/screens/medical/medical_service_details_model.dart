import 'package:cached_network_image/cached_network_image.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/medical_provider.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class MedicalServiceDetailsModel extends StatefulWidget {
  final int id;

  const MedicalServiceDetailsModel({this.id = 0, super.key});

  @override
  State<MedicalServiceDetailsModel> createState() => _MedicalServiceDetailsModelState();
}

class _MedicalServiceDetailsModelState extends State<MedicalServiceDetailsModel> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MedicalProvider>(context, listen: false).medicalHistoryDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Details'),
      body: Consumer<MedicalProvider>(
        builder: (context, medicalProvider, child) => ModalProgressHUD(
          inAsyncCall: medicalProvider.isLoading2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // padding: const EdgeInsets.all(10),
              children: [
                buildContainer('ID:', medicalProvider.medicalServiceDetailsModel.id.toString(), 0),
                buildContainer('Name:', medicalProvider.medicalServiceDetailsModel.name.toString(), 1),
                buildContainer('department:', medicalProvider.medicalServiceDetailsModel.department.toString(), 0),
                buildContainer('providerName:', medicalProvider.medicalServiceDetailsModel.providerName.toString(), 1),
                buildContainer('serviceType:', medicalProvider.medicalServiceDetailsModel.serviceType.toString(), 0),
                buildContainer('createdAt:', medicalProvider.medicalServiceDetailsModel.createdAt.toString(), 1),
                medicalProvider.medicalServiceDetailsModel.docuemntUrl!.isEmpty ||medicalProvider.isLoading2
                    ? spaceZero
                    : CachedNetworkImage(imageUrl: '${AppConstant.imageBaseMedicalUrl}${medicalProvider.medicalServiceDetailsModel.docuemntUrl}')
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainer(String title, String details, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration:
          BoxDecoration(color: index == 1 ? kPrimaryColor.withOpacity(.07) : kPrimaryColor.withOpacity(.15), borderRadius: BorderRadius.circular(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: robotoStyle600SemiBold.copyWith(color: kPrimaryColor)),
          spaceWeight15,
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(details, style: robotoStyle500Medium.copyWith(color: Colors.black)),
            ],
          )),
        ],
      ),
    );
  }
}
