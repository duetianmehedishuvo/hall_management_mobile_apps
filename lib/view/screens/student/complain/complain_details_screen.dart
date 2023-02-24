import 'package:duetstahall/data/model/response/complain_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/complain_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/complain/add_complain_screen.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComplainDetailsScreen extends StatefulWidget {
  final bool isAdmin;
  final int index;
  final ComplainModel complainModel;

  const ComplainDetailsScreen({this.isAdmin = false, this.index = 0, required this.complainModel, Key? key}) : super(key: key);

  @override
  State<ComplainDetailsScreen> createState() => _ComplainDetailsScreenState();
}

class _ComplainDetailsScreenState extends State<ComplainDetailsScreen> {
  final TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'Complain Details', borderRadius: 10),
        body: Consumer<ComplainProvider>(
          builder: (context, complainProvider, child) => complainProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(15),
                  children: [
                    Text('Subject:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                    SizedBox(height: 5),
                    Text(widget.complainModel.subject!, style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                    Divider(),
                    Text('Complain:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                    SizedBox(height: 5),
                    Text(widget.complainModel.complain!, style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                    Divider(),
                    Text('Administrator Reply:', style: robotoStyle700Bold.copyWith(fontSize: 16)),
                    SizedBox(height: 5),
                    Text(widget.complainModel.reply!.isEmpty ? "No Reply Found" : widget.complainModel.reply!,
                        style: robotoStyle400Regular.copyWith(color: Colors.black, fontSize: 14)),
                    Divider(),
                    widget.complainModel.reply!.isEmpty && widget.isAdmin
                        ? CustomTextField(
                            hintText: 'Write Here........',
                            isShowBorder: true,
                            controller: replyController,
                            verticalSize: 14,
                            labelText: 'Enter Reply Here',
                            inputType: TextInputType.text,
                            maxLines: 3,
                          )
                        : SizedBox(),
                    SizedBox(height: widget.complainModel.reply!.isEmpty && widget.isAdmin ? 10 : 0),
                    widget.complainModel.reply!.isEmpty && widget.isAdmin
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width: 90,
                                  child: CustomButton(
                                      btnTxt: 'Reply',
                                      onTap: () {
                                        if (replyController.text.isEmpty) {
                                          showMessage('Please Write a reply');
                                        } else {
                                          complainProvider
                                              .replyComplain(widget.complainModel.id as int, replyController.text)
                                              .then((value) {
                                            if (value['status'] == true) {
                                              Helper.back();
                                            }
                                          });
                                        }
                                      })),
                            ],
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        widget.isAdmin || widget.complainModel.reply!.isNotEmpty
                            ? SizedBox()
                            : CustomButton(
                                btnTxt: 'Edit',
                                onTap: () {
                                  Helper.toScreen(AddComplainScreen(isEdit: true, complainModel: widget.complainModel));
                                },
                              ),
                        SizedBox(height: 20),
                        widget.isAdmin || widget.complainModel.reply!.isEmpty
                            ? CustomButton(
                                btnTxt: 'Delete',
                                onTap: () {
                                  complainProvider.deleteComplain(widget.complainModel.id as int, widget.index).then((value) {
                                    Helper.back();
                                  });
                                },
                                backgroundColor: Colors.red)
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
        ));
  }
}
