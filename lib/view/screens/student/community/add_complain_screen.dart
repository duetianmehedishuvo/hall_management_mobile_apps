import 'package:duetstahall/data/model/response/complain_model.dart';
import 'package:duetstahall/provider/complain_provider.dart';
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

class AddComplainScreen extends StatefulWidget {
  final ComplainModel? complainModel;
  final bool isEdit;

  AddComplainScreen({this.complainModel, this.isEdit = false, super.key});

  @override
  State<AddComplainScreen> createState() => _AddComplainScreenState();
}

class _AddComplainScreenState extends State<AddComplainScreen> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController complainController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isEdit) {
      subjectController.text = widget.complainModel!.subject!;
      complainController.text = widget.complainModel!.complain!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "${widget.isEdit ? "Update" : "Add"} Complain"),
      body: AutofillGroup(
        child: Consumer<ComplainProvider>(
            builder: (context, complainProvider, child) => ModalProgressHUD(
                  inAsyncCall: complainProvider.isLoading,
                  progressIndicator:
                      const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColorLight)),
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                          CustomTextField(
                            hintText: 'Write Here........',
                            isShowBorder: true,
                            controller: subjectController,
                            verticalSize: 14,
                            labelText: 'Enter Complain Subject',
                            inputType: TextInputType.text,
                            maxLines: 3,
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                          CustomTextField(
                            hintText: 'Write here....',
                            isShowBorder: true,
                            controller: complainController,
                            verticalSize: 14,
                            maxLines: 10,
                            labelText: 'Enter Complain Details',
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'NOTE: this is very important and sensitive so please add before carefully, thanks',
                            style: robotoStyle600SemiBold.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                              btnTxt: '${widget.isEdit ? "Update" : "Add"}',
                              onTap: () {
                                if (subjectController.text.isEmpty) {
                                  showMessage('Please provide Complain Subject');
                                } else if (complainController.text.isEmpty) {
                                  showMessage('Please Write Details here...');
                                } else {
                                  if (widget.isEdit) {
                                    complainProvider
                                        .editComplain(widget.complainModel!.id! as int, subjectController.text, complainController.text)
                                        .then((value) {
                                      if (value == true) {
                                        subjectController.clear();
                                        complainController.clear();
                                        Helper.back();
                                        Helper.back();
                                      }
                                    });
                                  } else {
                                    complainProvider.addComplain(subjectController.text, complainController.text).then((value) {
                                      if (value == true) {
                                        subjectController.clear();
                                        complainController.clear();
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
