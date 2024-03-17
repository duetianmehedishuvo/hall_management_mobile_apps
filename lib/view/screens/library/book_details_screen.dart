import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/helper/open_call_url_map_sms_helper.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/library/add_book_screen.dart';
import 'package:duetstahall/view/screens/library/all_book_screen.dart';
import 'package:duetstahall/view/screens/library/check_card_screen.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatefulWidget {
  final bool isfromCheck;
  final int isUpdate;
  final int id;

  const BookDetailsScreen({this.isfromCheck = false, this.isUpdate = 0, this.id = 0, super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Details'),
      body: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, child) => ModalProgressHUD(
          inAsyncCall: libraryProvider.isLoading,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              buildContainer('Book-ID:', libraryProvider.bookModel.id.toString(), 0),
              buildContainer('Title:', libraryProvider.bookModel.title.toString(), 1),
              buildContainer('Category:', libraryProvider.bookModel.category.toString(), 0),
              buildContainer('Price:', '${libraryProvider.bookModel.price.toString()}৳', 1),
              buildContainer('Author:', libraryProvider.bookModel.author.toString(), 0),
              spaceHeight25,
              !widget.isfromCheck
                  ? spaceZero
                  : CustomButton(
                      btnTxt: widget.isUpdate == 0 ? 'Add Issue' : 'Update Issue',
                      onTap: () {
                        libraryProvider.bookIssue(widget.isUpdate, id: widget.id).then((value) {
                          if (value == true) {
                            Navigator.of(context).pop();
                          }
                        });
                      })
            ],
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
