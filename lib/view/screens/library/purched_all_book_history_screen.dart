import 'package:duetstahall/data/model/response/book_model.dart';
import 'package:duetstahall/data/model/response/book_purched_model.dart';
import 'package:duetstahall/data/model/response/hall_fee_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/hall_fee/hall_fee_details_screen.dart';
import 'package:duetstahall/view/screens/library/add_book_screen.dart';
import 'package:duetstahall/view/screens/library/all_book_screen.dart';
import 'package:duetstahall/view/screens/library/book_details_screen.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchedAllBookHistoryScreen extends StatefulWidget {
  final bool isAdmin;
  final bool isFromIssueBook;

  const PurchedAllBookHistoryScreen({this.isAdmin = true, this.isFromIssueBook = true, super.key});

  @override
  State<PurchedAllBookHistoryScreen> createState() => _PurchedAllBookHistoryScreenState();
}

class _PurchedAllBookHistoryScreenState extends State<PurchedAllBookHistoryScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isAdmin == false) {
      Provider.of<LibraryProvider>(context, listen: false).clearStudentID();
    }

    Provider.of<LibraryProvider>(context, listen: false).changePurchedType('All', isFirstTime: true);
    Provider.of<LibraryProvider>(context, listen: false).getBookPurchedHistory(isFromIssueBook: widget.isFromIssueBook);
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<LibraryProvider>(context, listen: false).hasNextDataCommend) {
        Provider.of<LibraryProvider>(context, listen: false).updateAllCommend(widget.isFromIssueBook);
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<LibraryProvider>(context, listen: false).getBookPurchedHistory(isFirstTime: false, isFromIssueBook: widget.isFromIssueBook);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Student Book Parched History', borderRadius: 0),
          body: Consumer<LibraryProvider>(
            builder: (context, libraryProvider, child) => libraryProvider.isLoadingCommend
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      !widget.isAdmin
                          ? spaceZero
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                  btnTxt: 'Add New Book Issue',
                                  onTap: () {
                                    Helper.toScreen(AllBookScreen(isFromCheckCard: true));
                                  }),
                            ),
                      libraryProvider.bookPurchedList.isEmpty ? noDataAvailable() : spaceZero,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: CupertinoColors.systemGrey), borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            selectedColor: AppColors.imageBGColorLight,
                            selectedTileColor: AppColors.imageBGColorLight,
                            splashColor: AppColors.imageBGColorLight,
                            tileColor: AppColors.imageBGColorLight,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            title: Text("Type", style: robotoStyle500Medium),
                            contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            trailing: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: false,
                                value: libraryProvider.selectPurchedType,
                                focusColor: AppColors.imageBGColorLight,
                                dropdownColor: AppColors.imageBGColorLight,
                                items: libraryProvider.purchedType.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: SizedBox(
                                        width: 150, //expand here
                                        child: Text(item, textAlign: TextAlign.end, style: robotoStyle600SemiBold)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  libraryProvider.changePurchedType(value.toString(), isCallAPI: true);
                                },
                                hint: const SizedBox(
                                  width: 150,
                                  child: Text("Select Type", style: TextStyle(color: Colors.grey), textAlign: TextAlign.end),
                                ),
                                style: const TextStyle(color: Colors.black, decorationColor: Colors.green),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: controller,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          children: [
                            ListView.builder(
                                itemCount: libraryProvider.bookPurchedList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  BookPurchedModel b = libraryProvider.bookPurchedList[index];
                                  return InkWell(
                                    onTap: () {
                                      if (b.status == 0 && widget.isAdmin == true) {
                                        Helper.toScreen(BookDetailsScreen(isfromCheck: true, isUpdate: 1, id: b.id as int));
                                      }
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shadowColor: Colors.grey.withOpacity(.2),
                                      elevation: 1,
                                      child: ListTile(
                                        title: Text(
                                            widget.isAdmin == true && widget.isFromIssueBook == false ? '${b.title!}\nID:${b.studentId}' : b.title!,
                                            style: robotoStyle500Medium.copyWith(fontSize: 15)),
                                        trailing: Text('${b.price!}৳\n${b.category}',
                                            style: robotoStyle700Bold.copyWith(fontSize: 15), textAlign: TextAlign.right),
                                        subtitle: Text('Author: ${b.author!}\nStatus: ${b.status == 0 ? 'Renew' : 'Return'}\nLast Update: ${b.updatedAt}',
                                            style: robotoStyle300Light.copyWith(fontSize: 15)),
                                      ),
                                    ),
                                  );
                                }),
                            libraryProvider.isBottomLoadingCommend
                                ? const Center(child: CircularProgressIndicator())
                                : libraryProvider.hasNextDataCommend
                                    ? InkWell(
                                        onTap: () {
                                          libraryProvider.updateAllCommend(widget.isFromIssueBook);
                                        },
                                        child: Container(
                                          height: 30,
                                          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(border: Border.all(color: colorText), borderRadius: BorderRadius.circular(22)),
                                          child: Text('Load more Data', style: robotoStyle500Medium.copyWith(color: colorText)),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }

// void route(HallFeeModel hallFeeModel, int index) {
//   Helper.toScreen(HallFeeDetailsScreen(hallFeeModel, isAdmin: widget.isAdmin, index: index));
// }
}
