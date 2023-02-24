import 'package:duetstahall/provider/hall_fee_provider.dart';
import 'package:duetstahall/provider/settings_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/sizeConfig.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/hall_fee/hall_fee_screen.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class HallFeeAdminScreen extends StatelessWidget {
  HallFeeAdminScreen({super.key});

  final TextEditingController amountController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Hall Fee"),
      body: AutofillGroup(
        child: Consumer<HallFeeProvider>(
            builder: (context, hallFeeProvider, child) => ModalProgressHUD(
                  inAsyncCall: hallFeeProvider.isLoading,
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
                          CustomButton(
                              btnTxt: 'Fine Hall Fee',
                              onTap: () {
                                hallFeeProvider.finalHallFee();
                              }),
                          SizedBox(height: 10),
                          CustomButton(
                              btnTxt: 'All History',
                              onTap: () {
                                Helper.toScreen(HallFeeScreen(isAdmin: true));
                              }),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              const Expanded(
                                  child: Text(
                                      '----------------------------------------------------------------------------------------------------------------------------------------------------',
                                      maxLines: 1)),
                              Text(' OR ', style: robotoStyle700Bold),
                              const Expanded(
                                  child: Text(
                                      '------------------------------------------------------------------------------------------------------------------------------------------',
                                      maxLines: 1)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 45,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(245, 246, 248, 1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: CupertinoColors.systemGrey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Fee Type: ', style: headline4),
                                SizedBox(
                                  width: 110,
                                  child: DropdownButton<String>(
                                    items: hallFeeProvider.feeType.map((blood) {
                                      return DropdownMenuItem<String>(
                                          value: blood, child: Text(blood, style: headline4, textAlign: TextAlign.center));
                                    }).toList(),
                                    underline: const SizedBox.shrink(),
                                    isExpanded: false,
                                    value: hallFeeProvider.selectFeeType,
                                    onChanged: (value) async {
                                      hallFeeProvider.changeFeeType(value!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                          CustomTextField(
                            hintText: 'Amount',
                            isShowBorder: true,
                            controller: amountController,
                            verticalSize: 14,
                            labelText: 'Enter Amount',
                            inputType: TextInputType.number,
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                          CustomTextField(
                            hintText: 'Purpose',
                            isShowBorder: true,
                            controller: purposeController,
                            verticalSize: 14,
                            maxLines: null,
                            labelText: 'Enter Purpose',
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'NOTE: this is very important and sensitive so please add before carefully, thanks',
                            style: robotoStyle600SemiBold.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          CustomButton(
                              btnTxt: 'Assign',
                              onTap: () {
                                if (amountController.text.isEmpty) {
                                  showMessage('Please provide amount');
                                } else if (purposeController.text.isEmpty) {
                                  showMessage('Please Write Purpose reasons');
                                } else if (int.tryParse(amountController.text) != null) {
                                  hallFeeProvider.addHallFee(int.parse(amountController.text), purposeController.text);
                                  amountController.clear();
                                  purposeController.clear();
                                } else {
                                  showMessage('Please provide Valid amount');
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
