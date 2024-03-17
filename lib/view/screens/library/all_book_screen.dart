import 'package:duetstahall/data/model/response/book_model.dart';
import 'package:duetstahall/data/model/response/hall_fee_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/hall_fee/hall_fee_details_screen.dart';
import 'package:duetstahall/view/screens/library/add_book_screen.dart';
import 'package:duetstahall/view/screens/library/book_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllBookScreen extends StatefulWidget {
  final bool isAdmin;
  final bool isFromCheckCard;

  const AllBookScreen({this.isAdmin = false, this.isFromCheckCard = false, super.key});

  @override
  State<AllBookScreen> createState() => _AllBookScreenState();
}

class _AllBookScreenState extends State<AllBookScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LibraryProvider>(context, listen: false).addBookCategoryItem(true);
    Provider.of<LibraryProvider>(context, listen: false).getAllCommunity();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange &&
          Provider.of<LibraryProvider>(context, listen: false).hasNextData) {
        Provider.of<LibraryProvider>(context, listen: false).updateAllCommunity();
      }
    });
  }

  Future<void> _refresh(BuildContext context) async {
    Provider.of<LibraryProvider>(context, listen: false).getAllCommunity(isFirstTime: false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _refresh(context);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'All Book List', borderRadius: 0),
          body: Consumer<LibraryProvider>(
            builder: (context, libraryProvider, child) => libraryProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
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
                                  libraryProvider.changeCategoryType(value.toString(), isCallAPI: true);
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
                      ),
                      Expanded(
                        child: ListView(
                          controller: controller,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          children: [
                            ListView.builder(
                                itemCount: libraryProvider.bookList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  BookModel b = libraryProvider.bookList[index];
                                  return InkWell(
                                    onLongPress: () {
                                      if (widget.isAdmin && widget.isFromCheckCard == false) {
                                        libraryProvider.selectBook(b);
                                        Helper.toScreen(BookDetailsScreen(isForBookHistory: true, id: b.id as int));
                                      }
                                    },
                                    onTap: () {
                                      if (widget.isAdmin && widget.isFromCheckCard == false) {
                                        Helper.toScreen(AddBookScreen(bookModel: b, isAdmin: widget.isAdmin, isUpdate: true));
                                      } else if (widget.isFromCheckCard) {
                                        libraryProvider.selectBook(b);
                                        Helper.toScreen(BookDetailsScreen(isfromCheck: widget.isFromCheckCard));
                                      } else {
                                        libraryProvider.selectBook(b);
                                        Helper.toScreen(const BookDetailsScreen());
                                      }
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shadowColor: Colors.grey.withOpacity(.2),
                                      elevation: 1,
                                      child: ListTile(
                                        title: Text(b.title!, style: robotoStyle500Medium.copyWith(fontSize: 15)),
                                        subtitle: Text('Author: ${b.author!}', style: robotoStyle300Light.copyWith(fontSize: 15)),
                                        trailing: Text('${b.price!}৳\n${b.category}',
                                            style: robotoStyle700Bold.copyWith(fontSize: 15), textAlign: TextAlign.right),
                                      ),
                                    ),
                                  );
                                }),
                            libraryProvider.isBottomLoading
                                ? const Center(child: CircularProgressIndicator())
                                : libraryProvider.hasNextData
                                    ? InkWell(
                                        onTap: () {
                                          libraryProvider.updateAllCommunity();
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

  void route(HallFeeModel hallFeeModel, int index) {
    Helper.toScreen(HallFeeDetailsScreen(hallFeeModel, isAdmin: widget.isAdmin, index: index));
  }

  DataColumn buildDataColumn(String title, String tooltips) =>
      DataColumn(label: Expanded(child: Center(child: Text(title, textAlign: TextAlign.center))), tooltip: tooltips);
}
