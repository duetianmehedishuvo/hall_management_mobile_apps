import 'package:duetstahall/dining/widgets/animated_button.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/dining/widgets/custome_text_fields.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/settings_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:provider/provider.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({Key? key}) : super(key: key);

  @override
  State<AddBalanceScreen> createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  Future<void> sslCommerzGeneralCall(StudentProvider studentProvider) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
            //Use the ipn if you have valid one, or it will fail the transaction.
            ipn_url: "https://www.duet.ac.bd/",
            multi_card_name: 'visa,master,bkash',
            currency: SSLCurrencyType.BDT,
            product_category: "Meal",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: 'duet62987ee0a6af1',
            store_passwd: 'duet62987ee0a6af1@ssl',
            total_amount: int.parse(amountController.text) * 1.0,
            tran_id: "1231321321321312"));
    sslcommerz.addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: 5,
            shipmentDetails: ShipmentDetails(
                shipAddress1: "Ship address 1",
                shipCity: "Faridpur",
                shipCountry: "Bangladesh",
                shipName: "Ship name 1",
                shipPostCode: "7860")));
    sslcommerz.addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "Gazipur",
            customerName: "Mehedi Hasan Shuvo",
            customerEmail: "sayem227@gmail.com",
            customerAddress1: "Anderkilla",
            customerCity: "Chattogram",
            customerPostCode: "200",
            customerCountry: "Bangladesh",
            customerPhone: '01777368276'));
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      showMessage(
        "the response is: ${result.amount!} code: ${result.cardNo!}",
      );
    } else {
      SSLCTransactionInfoModel model = result;
      showMessage("Transaction successful: Amount ${model.amount} TK", isError: false);
      _onConfirmed();

      studentProvider.updateBalance(amountController.text).then((value) {
        if (value['status'] == true) {
          amountController.text = '';
          Provider.of<AuthProvider>(context, listen: false).getUserInfo(isFirstTime: false);
        } else {
          showMessage('Balance Added Failed');
        }
      });
    }
  }

  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add  Balance'),
      body: Consumer2<StudentProvider, SettingsProvider>(builder: (context, studentProvider, settingsProvider, child) {
        return !studentProvider.isLoading
            ? Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomTextField(
                            hintText: 'Write Here.',
                            labelText: 'How Many Amount do you want to Add?',
                            isShowBorder: true,
                            borderRadius: 9,
                            verticalSize: 14,
                            hintFontSize: 13,
                            inputType: TextInputType.number,
                            inputAction: TextInputAction.done,
                            controller: amountController,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                            child: Text('Current Meal Rate : ${settingsProvider.configModel.mealRate}৳',
                                style: headline4.copyWith(fontSize: 14, color: AppColors.grey))),
                      ],
                    ),
                  ),
                  //Animated button
                  AnimatedButton(onComplete: () {
                    if (amountController.text.isEmpty) {
                      showMessage('Please Enter Amount First');
                    } else if (int.tryParse(amountController.text) != null) {
                      sslCommerzGeneralCall(studentProvider);
                    } else {
                      showMessage('Please Input Valid Integer Number like 1,2,3... Thanks.');
                    }
                  })
                ],
              )
            : const CustomLoader();
      }),
    );
  }

  void _onConfirmed() {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 72),
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, color: AppColors.primaryColorLight, size: 96),
                    Center(
                        child:
                            Text("Balance added successfully,Thanks", style: TextStyle(color: AppColors.primaryColorLight, fontSize: 16)))
                  ],
                ),
              ),
            ),
          );
        });
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
