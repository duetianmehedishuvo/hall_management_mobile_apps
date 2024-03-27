import 'package:duetstahall/data/model/response/medical_service_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/provider/medical_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMedicalServiceScreen extends StatefulWidget {
  final MedicalServiceModel? medicalServiceModel;
  final bool isAdmin;
  final bool isUpdate;

  const AddMedicalServiceScreen({this.medicalServiceModel, this.isAdmin = false, this.isUpdate = false, super.key});

  @override
  State<AddMedicalServiceScreen> createState() => _AddMedicalServiceScreenState();
}

class _AddMedicalServiceScreenState extends State<AddMedicalServiceScreen> {
  // String service_type, String provider_name, String details,
  TextEditingController serviceTypeController = TextEditingController();
  TextEditingController providerController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final FocusNode typeFocus = FocusNode();
  final FocusNode providerFocus = FocusNode();
  final FocusNode detailsFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LibraryProvider>(context, listen: false).addBookCategoryItem(false);
    serviceTypeController = TextEditingController();
    providerController = TextEditingController();
    detailsController = TextEditingController();

    if (widget.isUpdate) {
      serviceTypeController.text = widget.medicalServiceModel!.serviceType!;
      providerController.text = widget.medicalServiceModel!.providerName!;
      detailsController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${widget.isUpdate ? 'Update' : 'Add'} Service'),
      body: Consumer<MedicalProvider>(
        builder: (context, medicalProvider, child) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          physics: const BouncingScrollPhysics(),
          children: [
            CustomTextField(
              hintText: 'write here',
              labelText: 'Enter Service Type',
              controller: serviceTypeController,
              isShowBorder: true,
              focusNode: typeFocus,
              nextFocus: providerFocus,
              isShowSuffixIcon: true,
              maxLines: null,
              borderRadius: 10,
              verticalSize: 15,
            ),
            spaceHeight10,
            CustomTextField(
              hintText: 'write here',
              labelText: 'Enter Service Provider Name',
              controller: providerController,
              isShowBorder: true,
              focusNode: providerFocus,
              nextFocus: detailsFocus,
              isShowSuffixIcon: true,
              maxLines: null,
              borderRadius: 10,
              verticalSize: 15,
            ),
            spaceHeight10,
            CustomTextField(
              hintText: 'write here',
              labelText: 'Enter Details Information',
              controller: detailsController,
              isShowBorder: true,
              focusNode: detailsFocus,
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
              isShowSuffixIcon: true,
              maxLines: null,
              borderRadius: 10,
              verticalSize: 15,
            ),
            spaceHeight20,
            InkWell(
              onTap: () {
                medicalProvider.pickImage();
              },
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 26,
                  ),
                  Text("Upload Image Files", style: robotoStyle400Regular.copyWith(fontSize: 15, color: kPrimaryColor)),
                ],
              ),
            ),
            medicalProvider.imageFile == null ? spaceZero : const SizedBox(height: 2),
            medicalProvider.imageFile == null ? spaceZero : Image.file(medicalProvider.imageFile!),
            spaceHeight20,
            medicalProvider.isLoading
                ? const CustomLoader()
                : CustomButton(
                    btnTxt: !widget.isUpdate ? 'Add' : 'Update',
                    onTap: () {
                      if (serviceTypeController.text.isEmpty || providerController.text.isEmpty || detailsController.text.isEmpty) {
                        showMessage('Please write all of the information');
                      } else {
                        medicalProvider
                            .addMedicalService(serviceTypeController.text, providerController.text, detailsController.text, widget.isUpdate ? 1 : 0,
                                id: widget.isUpdate ? widget.medicalServiceModel!.id as int : -1)
                            .then((value) {
                          if (value == true) {
                            Helper.back();
                          }
                        });
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}
