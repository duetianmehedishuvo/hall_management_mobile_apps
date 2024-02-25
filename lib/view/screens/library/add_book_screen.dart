import 'package:duetstahall/data/model/response/book_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:duetstahall/view/widgets/custom_text_field.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatefulWidget {
  final BookModel? bookModel;
  final bool isAdmin;
  final bool isUpdate;

  const AddBookScreen({this.bookModel, this.isAdmin = false, this.isUpdate = false, super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final FocusNode titleFocus = FocusNode();
  final FocusNode authorFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LibraryProvider>(context, listen: false).addBookCategoryItem(false);
    titleController = TextEditingController();
    authorController = TextEditingController();
    priceController = TextEditingController();

    if (widget.isUpdate) {
      titleController.text = widget.bookModel!.title!;
      authorController.text = widget.bookModel!.author!;
      priceController.text = widget.bookModel!.price!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${widget.isUpdate ? 'Update' : 'Add'} Book'),
      body: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, child) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          physics: const BouncingScrollPhysics(),
          children: [
            spaceHeight5,
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(side: const BorderSide(width: 1, color: CupertinoColors.systemGrey), borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(bottom: 3),
              child: ListTile(
                selectedColor: AppColors.imageBGColorLight,
                selectedTileColor: AppColors.imageBGColorLight,
                splashColor: AppColors.imageBGColorLight,
                tileColor: AppColors.imageBGColorLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                title: Text("Book Category", style: robotoStyle500Medium),
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: false,
                    value: libraryProvider.selectCategoryType,
                    focusColor: AppColors.imageBGColorLight,
                    dropdownColor: AppColors.imageBGColorLight,
                    items: libraryProvider.categoryType.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: SizedBox(
                            width: 150, //expand here
                            child: Text(item, textAlign: TextAlign.end, style: robotoStyle600SemiBold)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      libraryProvider.changeCategoryType(value.toString());
                    },
                    hint: const SizedBox(
                      width: 150,
                      child: Text("Select Book Item", style: TextStyle(color: Colors.grey), textAlign: TextAlign.end),
                    ),
                    style: const TextStyle(color: Colors.black, decorationColor: Colors.green),
                  ),
                ),
              ),
            ),
            spaceHeight10,
            CustomTextField(
              hintText: 'write here',
              labelText: 'Enter Book title',
              controller: titleController,
              isShowBorder: true,
              focusNode: titleFocus,
              nextFocus: authorFocus,
              isShowSuffixIcon: true,
              maxLines: null,
              borderRadius: 10,
              verticalSize: 15,
            ),
            spaceHeight10,
            CustomTextField(
              hintText: 'write here',
              labelText: 'Enter Author Name',
              controller: authorController,
              isShowBorder: true,
              focusNode: authorFocus,
              nextFocus: priceFocus,
              isShowSuffixIcon: true,
              maxLines: null,
              borderRadius: 10,
              verticalSize: 15,
            ),
            spaceHeight10,
            CustomTextField(
              hintText: 'write here',
              labelText: 'Enter Book Price',
              controller: priceController,
              isShowBorder: true,
              focusNode: priceFocus,
              inputAction: TextInputAction.done,
              inputType: TextInputType.number,
              isShowSuffixIcon: true,
              maxLines: null,
              borderRadius: 10,
              verticalSize: 15,
            ),
            spaceHeight20,
            libraryProvider.isLoading
                ? const CustomLoader()
                : CustomButton(
                    btnTxt: !widget.isUpdate ? 'Add' : 'Update',
                    onTap: () {
                      if (titleController.text.isEmpty || authorController.text.isEmpty || priceController.text.isEmpty) {
                        showMessage('Please write all of the information');
                      } else {
                        libraryProvider
                            .addBook(titleController.text, authorController.text, priceController.text, widget.isUpdate ? 1 : 0,
                                id: widget.isUpdate ? widget.bookModel!.id as int : -1)
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
