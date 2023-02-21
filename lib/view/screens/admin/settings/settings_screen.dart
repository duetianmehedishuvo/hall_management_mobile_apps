import 'package:duetstahall/provider/settings_provider.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/custom_app_bar.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final TextEditingController currentMealRateController = TextEditingController();
  final TextEditingController guestMealRateController = TextEditingController();
  final TextEditingController otherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Settings"),
      body: AutofillGroup(
        child: Consumer<SettingsProvider>(
            builder: (context, settingProvider, child) => ModalProgressHUD(
                  inAsyncCall: settingProvider.isLoading,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Guest Meal Status:',
                                  style: robotoStyle500Medium.copyWith(color: AppColors.primaryColorLight, fontSize: 17)),
                              Switch(
                                  value: settingProvider.hasAvailableGuestMeal,
                                  activeColor: AppColors.primaryColorLight,
                                  onChanged: (value) {
                                    settingProvider.changeGuestAccess(value);
                                  })
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.2),
                                      blurRadius: 10.0,
                                      spreadRadius: 3.0,
                                      offset: const Offset(0.0, 0.0))
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    settingProvider.changeActiveStatus(0);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text('Current Meal Rate: ${settingProvider.configModel.mealRate}৳',
                                            style: robotoStyle600SemiBold.copyWith(fontSize: 15)),
                                      ),
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: AppColors.primaryColorLight,
                                        child: Icon(
                                          settingProvider.hasActiveCurrentMeal ? Icons.arrow_upward_outlined : Icons.arrow_downward,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: !settingProvider.hasActiveCurrentMeal ? 0 : 20),
                                !settingProvider.hasActiveCurrentMeal
                                    ? const SizedBox.shrink()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              hintText: 'Write Amount',
                                              isShowBorder: true,
                                              verticalSize: 12,
                                              controller: currentMealRateController,
                                              inputAction: TextInputAction.done,
                                              inputType: TextInputType.number,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 100,
                                            child: CustomButton(
                                              btnTxt: 'Submit',
                                              onTap: () {
                                                if (currentMealRateController.text.isEmpty) {
                                                  showMessage('Please Enter a Amount');
                                                } else {
                                                  settingProvider.updateMealRate(int.parse(currentMealRateController.text), false);
                                                  FocusScope.of(context).unfocus();
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                SizedBox(height: !settingProvider.hasActiveCurrentMeal ? 0 : 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.2),
                                      blurRadius: 10.0,
                                      spreadRadius: 3.0,
                                      offset: const Offset(0.0, 0.0))
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    settingProvider.changeActiveStatus(1);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text('Guest Meal Rate: ${settingProvider.configModel.guestMealRate}৳',
                                            style: robotoStyle600SemiBold.copyWith(fontSize: 15)),
                                      ),
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: AppColors.primaryColorLight,
                                        child: Icon(
                                          settingProvider.hasActiveGuestMeal ? Icons.arrow_upward_outlined : Icons.arrow_downward,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: !settingProvider.hasActiveGuestMeal ? 0 : 20),
                                !settingProvider.hasActiveGuestMeal
                                    ? const SizedBox.shrink()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              hintText: 'Write Amount',
                                              isShowBorder: true,
                                              verticalSize: 12,
                                              controller: guestMealRateController,
                                              inputAction: TextInputAction.done,
                                              inputType: TextInputType.number,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 100,
                                            child: CustomButton(
                                              btnTxt: 'Submit',
                                              onTap: () {
                                                if (guestMealRateController.text.isEmpty) {
                                                  showMessage('Please Enter a Amount');
                                                } else {
                                                  settingProvider.updateMealRate(int.parse(guestMealRateController.text), true);
                                                  FocusScope.of(context).unfocus();
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                SizedBox(height: !settingProvider.hasActiveGuestMeal ? 0 : 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.2),
                                      blurRadius: 10.0,
                                      spreadRadius: 3.0,
                                      offset: const Offset(0.0, 0.0))
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    settingProvider.changeActiveStatus(2);
                                    if (settingProvider.hasActiveOther == true) {
                                      otherController.text = settingProvider.configModel.offlineTakaLoadTime!;
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(child: Text('Service Time:', style: robotoStyle600SemiBold.copyWith(fontSize: 15))),
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: AppColors.primaryColorLight,
                                        child: Icon(
                                          settingProvider.hasActiveOther ? Icons.arrow_upward_outlined : Icons.arrow_downward,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('${settingProvider.configModel.offlineTakaLoadTime}',
                                    style: robotoStyle300Light.copyWith(fontSize: 15)),
                                SizedBox(height: !settingProvider.hasActiveOther ? 0 : 20),
                                !settingProvider.hasActiveOther
                                    ? const SizedBox.shrink()
                                    : Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              hintText: 'Write Text',
                                              isShowBorder: true,
                                              verticalSize: 12,
                                              controller: otherController,
                                              inputAction: TextInputAction.done,
                                              inputType: TextInputType.text,
                                              maxLines: null,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 60,
                                            child: CustomButton(
                                              btnTxt: 'OK',
                                              onTap: () {
                                                if (otherController.text.isEmpty) {
                                                  showMessage('Write Here...');
                                                } else {
                                                  settingProvider.updateOfflineTakaCollectTime(otherController.text);
                                                  FocusScope.of(context).unfocus();
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                SizedBox(height: !settingProvider.hasActiveOther ? 0 : 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
