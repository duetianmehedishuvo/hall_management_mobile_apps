import 'package:duetstahall/data/model/response/book_history_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/provider/library_provider.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/util/size.util.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:duetstahall/view/screens/student/students/student_details_screen.dart';
import 'package:duetstahall/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatefulWidget {
  final bool isfromCheck;
  final bool isForBookHistory;
  final int isUpdate;
  final int id;

  const BookDetailsScreen({this.isfromCheck = false, this.isForBookHistory = false, this.isUpdate = 0, this.id = 0, super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isForBookHistory == true) {
      Provider.of<LibraryProvider>(context, listen: false).getBookHistory(widget.id);
      controller.addListener(() {
        if (controller.offset >= controller.position.maxScrollExtent &&
            !controller.position.outOfRange &&
            Provider.of<LibraryProvider>(context, listen: false).hasNextDataCommend) {
          Provider.of<LibraryProvider>(context, listen: false).updateAllBookHistory(widget.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Details'),
      body: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, child) => ModalProgressHUD(
          inAsyncCall: libraryProvider.isLoading,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // padding: const EdgeInsets.all(10),
              children: [
                buildContainer('Book-ID:', libraryProvider.bookModel.id.toString(), 0),
                buildContainer('Title:', libraryProvider.bookModel.title.toString(), 1),
                buildContainer('Category:', libraryProvider.bookModel.category.toString(), 0),
                buildContainer('Price:', '${libraryProvider.bookModel.price.toString()}৳', 1),
                buildContainer('Author:', libraryProvider.bookModel.author.toString(), 0),
                widget.isForBookHistory == true ? spaceZero : spaceHeight25,
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
                        }),
                // widget.isForBookHistory == false ? spaceZero : spaceHeight25,
                widget.isForBookHistory == false
                    ? spaceZero
                    : libraryProvider.isLoadingCommend
                        ? const Center(child: CircularProgressIndicator())
                        : libraryProvider.bookHistoryList.isEmpty
                            ? noDataAvailable()
                            : Expanded(
                                child: ListView(
                                  controller: controller,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  children: [
                                    spaceHeight5,
                                    Center(child: Text('All History', style: robotoStyle600SemiBold.copyWith(fontSize: 16))),
                                    Divider(),
                                    ListView.builder(
                                        itemCount: libraryProvider.bookHistoryList.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          BookHistoryModel b = libraryProvider.bookHistoryList[index];
                                          return InkWell(
                                            onTap: () {
                                              Helper.toScreen(StudentDetailsScreen(b.studentId.toString()));
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              shadowColor: Colors.grey.withOpacity(.2),
                                              elevation: 1,
                                              child: ListTile(
                                                title: Text('S-ID: ${b.studentId!.toString()}', style: robotoStyle500Medium.copyWith(fontSize: 15)),
                                                trailing:
                                                    Text('${b.department}', style: robotoStyle700Bold.copyWith(fontSize: 15), textAlign: TextAlign.right),
                                                subtitle: Text('Name: ${b.name}', style: robotoStyle300Light.copyWith(fontSize: 15)),
                                              ),
                                            ),
                                          );
                                        }),
                                    libraryProvider.isBottomLoadingCommend
                                        ? const Center(child: CircularProgressIndicator())
                                        : libraryProvider.hasNextDataCommend
                                            ? InkWell(
                                                onTap: () {
                                                  libraryProvider.updateAllBookHistory(widget.id);
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
