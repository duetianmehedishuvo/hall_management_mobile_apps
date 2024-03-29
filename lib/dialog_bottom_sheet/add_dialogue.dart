import 'package:duetstahall/provider/community_provider.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_inkwell_btn.dart';
import 'package:duetstahall/view/widgets/custom_text.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddDialogue extends StatefulWidget {
  final String? title;
  final bool? isUpdate;
  final bool? isPost;
  final int? id;

  const AddDialogue({this.title, this.id = -1, this.isUpdate = false, this.isPost = true, super.key});

  @override
  State<AddDialogue> createState() => _AddDialogueState();
}

class _AddDialogueState extends State<AddDialogue> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdate == true) {
      messageController = TextEditingController();
      messageController.text = widget.title!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: Colors.white,
        child: Consumer<CommunityProvider>(
          builder: (context, communityProvider, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Space
              const SizedBox(height: 10),
              //f
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomText(
                            title: '${widget.isUpdate! ? "Update" : "Write"} your ${widget.isPost! ? "community post" : "Comment"}?',
                            fontSize: 14,
                            color: Colors.black,
                            maxLines: 2,
                            textAlign: TextAlign.center)),
                    CustomInkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.clear, color: Theme.of(context).textTheme.displayLarge!.color!),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomTextField(
                  hintText: 'Write here...',
                  isShowBorder: true,
                  verticalSize: 14,
                  labelText: 'Write here',
                  controller: messageController,
                  inputAction: TextInputAction.done,
                  borderRadius: 8,
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 10),

              //NO YES
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                child: communityProvider.isLoading||communityProvider.isLoadingCommend
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              btnTxt: 'No',
                              backgroundColor: Colors.black,
                              textWhiteColor: true,
                              fontSize: 17,
                            ),
                          ),
                          //Space
                          const SizedBox(width: 5),
                          Expanded(
                            child: CustomButton(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (messageController.text.isEmpty) {
                                  Fluttertoast.showToast(msg: "Please Write Somethings", backgroundColor: Colors.red);
                                } else {
                                  if (widget.isPost!) {
                                    communityProvider.addPost(messageController.text, widget.isUpdate == true ? 1 : 0, id: widget.id!).then((value) {
                                      if (value) {
                                        messageController.clear();
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    communityProvider
                                        .commend( messageController.text, widget.isUpdate == true ? 1 : 0, id: widget.id!)
                                        .then((value) {
                                      if (value) {
                                        messageController.clear();
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                }
                              },
                              btnTxt: widget.isUpdate! ? 'Update' : 'Add',
                              fontSize: 17,
                              backgroundColor: Colors.green,
                              textWhiteColor: true,
                            ),
                          ),
                        ],
                      ),
              ),
              //Space
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
